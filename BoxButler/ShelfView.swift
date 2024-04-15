//
//  MainView.swift
//  BoxButler
//
//  Created by 64014784 on 3/3/24.
//
import SwiftData
import SwiftUI
import PhotosUI

struct ShelfView: View {
    @Environment(\.modelContext) var modelContext
    @State private var isShowingSelectionSheet = false
    @State private var navPath = NavigationPath()
    @Query var boxes: [Box]
    @Query var items: [Item]
    @State var currentItem: Item = Item(itemName: "", quantity: "", price: 0.0, itemDetails: "", location: [])
    
    var body: some View {
            ZStack {
                Color.clear
                NavigationStack(path: $navPath){
                        if !items.isEmpty || !boxes.isEmpty {
                        Text("Swipe left to delete items.")
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, -165.0)
                            .padding(.top, 2)
                        }
                        ItemsListView()
                        .navigationDestination(for: Item.self) {item in 
                            ZStack{
                                Color.clear
                                EditItemView(item: item)}
                            }
                            .ignoresSafeArea(.keyboard)
                        .navigationDestination(for: Box.self) {box in EditBoxView(box: box)}
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .navigationTitle("Box Butler")
                    .sheet(isPresented: $isShowingSelectionSheet, content: {
                        selectionSheet(isShowingSelectionSheet: $isShowingSelectionSheet)
                            .presentationDetents([.height(200), .medium, .large])

                    })
                    .navigationTitle("Box Butler")
                HStack {
                    Spacer()
                        .frame(width: 255)
                    VStack {
                        Spacer()
                            .frame(height: 600)
                            Button(action: { isShowingSelectionSheet = true
                            }) {
                                Image(systemName: "plus")
                                    .frame(minWidth: 0, maxWidth: 40)
                                    .frame(minHeight: 0, maxHeight: 40)
                                    .font(.system(size: 26))
                                    .padding()
                                    .foregroundColor(.white)

                            }
                            .background(Color.red.opacity(0.65))
                            .cornerRadius(25)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
    }

    
    struct selectionSheet: View {
        @Environment(\.modelContext) var modelContext
        @Environment(\.dismiss) private var dismiss
        @State private var isShowingItemSheet = false
        @State private var isShowingBoxSheet = false
        @Binding var isShowingSelectionSheet: Bool
        @Query var boxes: [Box]
        @Query var items: [Item]
        @State var currentItem: Item = Item(itemName: "", quantity: "", price: 0.0, itemDetails: "", location: [])
        @State var currentBox: Box = Box(boxName: "", boxQuantity: "", price: 0.0, boxDetails: "", location: [])

        var body: some View{
            NavigationStack{
                Button{
                    currentItem = addItem()
                    isShowingItemSheet = true
                } label:{
                    Image(systemName: "pencil")
                    Text("Add Item")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)

                }
                .buttonStyle(.borderedProminent)
                Button{
                    currentBox = addBox()
                    isShowingBoxSheet = true
                } label: {
                    Image(systemName: "shippingbox.fill")
                    Text("Add Box")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                }
                .buttonStyle(.borderedProminent)
            }
            .sheet(isPresented: $isShowingItemSheet, content: {
                addItemSheet(item: currentItem)
            })
            .sheet(isPresented: $isShowingBoxSheet, content: {
                addBoxSheet(box: currentBox)
            })
            
        }
        func addItem() -> Item {
            let item = Item(itemName: "", quantity: "", price: 0.0, itemDetails: "", location: [])
            modelContext.insert(item)
            return item
        }
        func addBox() -> Box {
            let box = Box(boxName: "", boxQuantity: "", price: 0.0, boxDetails: "", location: [])
            modelContext.insert(box)
            return box
        }
    }
    
    struct addItemSheet: View {
        @Environment(\.dismiss) private var dismiss
        @Environment(\.modelContext) var modelContext
        @Query var items: [Item]
        @Bindable var item: Item
        @State private var selectedItem: PhotosPickerItem?
        @State private var isShowingAddLocationSheet = false
        
        
        var body: some View {
            NavigationStack{
                Form {
                    Section{
                        if let imageData = item.photo, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        }
                        
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Label("Select a photo",systemImage: "camera.on.rectangle")
                        }
                    }
                    
                    Section {
                        TextField("Item Name", text: $item.itemName)
                        TextField("Quantity", text: $item.quantity)
                            .keyboardType(.numberPad)
                        TextField("Price", value: $item.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.numberPad)

                    }
                    Button("Add Location Tag"){
                        isShowingAddLocationSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                    .background(.red)
                    .cornerRadius(10)
                    Section("Notes"){
                        TextField("Details about this Item", text: $item.itemDetails, axis: .vertical)
                    }
                    
                }
                .navigationTitle("Edit Item")
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: selectedItem, loadPhoto)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button ("Cancel") {
                            if item.itemName == "" && item.quantity == "" && item.price == 0.0 && item.itemDetails == "" && item.location == [] {
                                modelContext.delete(item)
                            }
                            dismiss()
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing){
                        Button("Save") {
                            if item.itemName == ""{
                                item.itemName = "Unnamed Item"
                            }
                            dismiss()
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingAddLocationSheet, content: {
                AddItemLocationSheet(item: item)
            })
        }
        func loadPhoto () {
            Task { @MainActor in
                item.photo = try await
                selectedItem?.loadTransferable(type: Data.self)
            }
        }
    }
    
    struct addBoxSheet: View{
        @Environment(\.dismiss) private var dismiss
        @Environment(\.modelContext) var modelContext
        @Bindable var box: Box
        @State private var selectedItem: PhotosPickerItem?
        
        var body: some View{
            NavigationStack{
                Form {
                    Section{
                        if let imageData = box.photo, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        }
                        
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Label("Select a photo",systemImage: "camera.on.rectangle")
                        }
                    }
                    Section ("Box Name") {
                        TextField("Box Name", text: $box.boxName)
                        TextField("Units Per Box", text: $box.boxQuantity)
                        TextField("Price", value: $box.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                }
                .navigationTitle("Edit Box")
                .onChange(of: selectedItem, loadPhoto)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button ("Cancel") {
                            if box.boxName == "" && box.boxQuantity == "" && box.price == 0.0 && box.boxDetails == "" && box.location == [] {
                                modelContext.delete(box)
                            }
                            dismiss()
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing){
                        Button("Save") {
                            if box.boxName == ""{
                                box.boxName = "Unnamed Box"
                            }
                            dismiss()
                        }
                    }
                }
            }
        }
        
        func loadPhoto () {
            Task { @MainActor in
                box.photo = try await
                selectedItem?.loadTransferable(type: Data.self)
            }
        }
        
    }
    
    
}


#Preview {
    ShelfView()
}
