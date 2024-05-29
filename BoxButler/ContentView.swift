//
//  ContentView.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//
import SwiftData
import SwiftUI
import PhotosUI
import VisionKit

enum Tab: Int {
       case first, second, third, fourth
   }

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = [Item]()
    @Query var boxes: [Box]
    @Query var items: [Item]
    @State var currentItem: Item = Item(itemName: "", quantity: "", price: 0.0, itemDetails: "", location: [], quantityWarn: "")
    @EnvironmentObject var scanState: ScanState
    
    @State private var selectedTab = Tab.first
    @State private var isShowingAddLocationSheet = false
    @State private var isShowingSelectionSheet = false
    @State var shouldShowPlus: Bool = false
    @State private var navPath = NavigationPath()
    @State private var notificationCount: String = ""
    @State private var isSaved = true
    @State var activeTagArray: [LocationTag] = []
    @State var availableTagArray: [LocationTag] = []
    @State var search = false
    @State private var searchText = ""
    
    var body: some View {
           VStack(spacing: 0) {
               ZStack {
                   if selectedTab == .first {
                       HomeView(notificationCount: $notificationCount)
                   }
                   else if selectedTab == .second {
                       NavigationStack(path: $navPath){
                           ItemsListView(selectedTab: $selectedTab, search: $search, hasSearched: $search)
                               .overlay{
                                   if items.isEmpty && boxes.isEmpty{
                                       ContentUnavailableView(label: {
                                           Label("No Items", systemImage: "circle.grid.3x3.fill")
                                       }, description: {
                                           Text("Click the plus to add items.")
                                       })
                                   }
                               }
                               .navigationDestination(for: Item.self) {item in EditItemView(item: item, isShowingAddLocationSheet: $isShowingAddLocationSheet, shouldShowPlus: $shouldShowPlus)
                                       .sheet(isPresented: $isShowingAddLocationSheet, content: {
                                           AddItemLocationSheet(item: item, isSaved: $isSaved, activeTagArray: $activeTagArray, availableTagArray: $availableTagArray)
                                       })}
                               .navigationDestination(for: Box.self) {box in EditBoxView(box: box, isShowingAddLocationSheet: $isShowingAddLocationSheet, shouldShowPlus: $shouldShowPlus)
                                       .sheet(isPresented: $isShowingAddLocationSheet, content: {
                                           AddBoxLocationSheet(box: box, isSaved: $isSaved, activeTagArray: $activeTagArray, availableTagArray: $availableTagArray)
                                       })}
                               .onAppear{
                                   shouldShowPlus = false
                               }
                                tabBarView
                               
                           }
                           .ignoresSafeArea(.keyboard, edges: .bottom)
                           .sheet(isPresented: $isShowingSelectionSheet, content: {
                               selectionSheet(isShowingSelectionSheet: $isShowingSelectionSheet)
                                   .presentationDetents([.height(200), .medium, .large])
                           })
                       HStack {
                           VStack {
                                Spacer()
                                   .frame(height: 525)
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
                                   .opacity(shouldShowPlus ? 0 : 1)
                           }
                           Spacer()
                               .frame(width: 255)
                       }
                   }
                   else if selectedTab == .third {
      
                           SearchView(selectedTab: $selectedTab)

                   }
                   else if selectedTab == .fourth {
                       SettingsView()
                    }
               }
               .transaction { transaction in
                   transaction.animation = nil
               }
               if selectedTab != .second && selectedTab != .third {
                   tabBarView
               }
           }
       }
       
    var tabBarView: some View {
        ZStack{
            VStack(spacing: 0) {
                Divider()
                    .frame(height: 0.8)
                    .overlay(.gray)
                    .opacity(0.5)
                
                HStack(spacing: 9) {
                    tabBarItem(.first, title: "Home", icon: "house", selectedIcon: "house.fill", notification: true)
                    tabBarItem(.second, title: "Shelf", icon: "shippingbox", selectedIcon: "shippingbox.fill", notification: false)
                    tabBarItem(.third, title: "Search", icon: "magnifyingglass", selectedIcon: "magnifyingglass", notification: false)
                    tabBarItem(.fourth, title: "Settings", icon: "gear", selectedIcon: "gear", notification: false)
                }
                .padding(.top, 20)
            }
            .frame(height: 61)
            .background(Color("TabColor").edgesIgnoringSafeArea(.all))
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }

       
    func tabBarItem(_ tab: Tab, title: String, icon: String, selectedIcon: String, notification: Bool) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 3) {
                VStack {
                    ZStack{
                        Image(systemName: (selectedTab == tab ? selectedIcon : icon))
                            .font(selectedTab == tab ? .system(size: 24).weight(.heavy) : .system(size: 24))
                            .foregroundColor(selectedTab == tab ? .primary : Color("TextColor"))
                        if notification {
                            if notificationCount != ""{
                                ZStack{
                                    Image(systemName: "circlebadge.fill")
                                        .font(.system(size: 21))
                                    Text(notificationCount)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .foregroundColor(Color(.white))
                                        .font(.system(size: 11))
                                }
                                .padding(.leading, 15)
                                .padding(.bottom, 15)
                            }
                        }
                    }
                }
                .frame(width: 55, height: 28)
                
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(selectedTab == tab ? .primary : Color("TextColor"))
            }
        }
        .frame(width: 65, height: 42)
        .onTapGesture {
            selectedTab = tab
        }
    }
    
    struct selectionSheet: View {
        @Environment(\.modelContext) var modelContext
        @Environment(\.dismiss) private var dismiss
        @State private var isShowingItemSheet = false
        @State private var isShowingBoxSheet = false
        @Binding var isShowingSelectionSheet: Bool
        @Query var boxes: [Box]
        @Query var items: [Item]

        var body: some View{
            NavigationStack{
                Button{
                    isShowingItemSheet = true
                } label:{
                    Image(systemName: "pencil")
                    Text("Add Item")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)

                }
                .buttonStyle(.borderedProminent)
                Button{
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
                addItemSheet(item: addItem(), isShowingSelectionSheet: $isShowingSelectionSheet)
            })
            .sheet(isPresented: $isShowingBoxSheet, content: {
                addBoxSheet(box: addBox(), isShowingSelectionSheet: $isShowingSelectionSheet)
            })
            
        }
        func addItem() -> Item {
            let item = Item(itemName: "", quantity: "", price: 0.0, itemDetails: "", location: [], quantityWarn: "")
            return item
        }
        func addBox() -> Box {
            let box = Box(boxName: "", boxQuantity: "", price: 0.0, boxDetails: "", location: [])
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
        @Binding var isShowingSelectionSheet: Bool
        @State var isShowingEmptyAlert: Bool = false
        @State private var isSaved = false
        @State var activeTagArray: [LocationTag] = []
        @State var availableTagArray: [LocationTag] = []
        
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
                    
                    Section("Quantity Warning Threshold"){
                        TextField("Min Level", text:$item.quantityWarn)
                            .keyboardType(.numberPad)
                    }
                    Section{
                        HStack{
                            Button{
                                isShowingAddLocationSheet = true
                            } label: {
                                Text("Edit Location Tags")
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    ForEach(activeTagArray) { tag in
                        HStack{
                            Text(tag.name)
                                .foregroundColor(Color.white)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(height: 27)
                                .background(Rectangle().fill(Color(.red))
                                    .opacity(0.8))
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                }
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
                            isShowingSelectionSheet = false
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing){
                        Button("Save") {
                            if item.itemName == ""{
                                isShowingEmptyAlert = true
                            }
                            else{
                                dismiss()
                                for tag in activeTagArray{
                                    item.location.append(tag)
                                    modelContext.insert(tag)
                                }
                                for tag in availableTagArray {
                                    modelContext.insert(tag)
                                }
                                modelContext.insert(item)
                                isShowingSelectionSheet = false
                                let change = Change(changeType: "New item created", originalVar: "nonexistant item", newVar: item.itemName, nameOfChangedItem: item.itemName, date: dateFormatter(date: Date()))
                                modelContext.insert(change)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingAddLocationSheet, content: {
                AddItemLocationSheet(item: item, isSaved: $isSaved, activeTagArray: $activeTagArray, availableTagArray: $availableTagArray)
            })
            .alert(isPresented: $isShowingEmptyAlert) {
                Alert(title: Text("Cannot Leave Item Title Blank"), dismissButton: .default(Text("Ok")))
            }
        }
        func loadPhoto () {
            Task { @MainActor in
                item.photo = try await
                selectedItem?.loadTransferable(type: Data.self)
            }
        }
        
        func dateFormatter(date: Date) -> String{
            let date = date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "M/d/yy h:mm a"
            formatter.timeZone = TimeZone(abbreviation: "CST")!  // Set to CST time zone

            let formattedDate = formatter.string(from: date)
            return(formattedDate)
        }
    }
    
    struct addBoxSheet: View{
        @Environment(\.dismiss) private var dismiss
        @Environment(\.modelContext) var modelContext
        @Bindable var box: Box
        @State private var selectedItem: PhotosPickerItem?
        @State private var isShowingAddLocationSheet = false
        @Binding var isShowingSelectionSheet: Bool
        @State var isShowingEmptyAlert: Bool = false
        @State private var isSaved = false
        @State var activeTagArray: [LocationTag] = []
        @State var availableTagArray: [LocationTag] = []

        
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
                    Section{
                        HStack{
                            Button{
                                isShowingAddLocationSheet = true
                            } label: {
                                Text("Edit Location Tags")
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    ForEach(activeTagArray) { tag in
                        HStack{
                            Text(tag.name)
                                .foregroundColor(Color.white)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(height: 27)
                                .background(Rectangle().fill(Color(.red))
                                    .opacity(0.8))
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
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
                            isShowingSelectionSheet = false
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing){
                        Button("Save") {
                            if box.boxName == ""{
                                isShowingEmptyAlert = true
                            }
                            else{
                                dismiss()
                                for tag in activeTagArray{
                                    box.location.append(tag)
                                    modelContext.insert(tag)
                                }
                                for tag in availableTagArray {
                                    modelContext.insert(tag)
                                }
                                modelContext.insert(box)
                                let change = Change(changeType: "New box created", originalVar: "nonexistant item", newVar: box.boxName, nameOfChangedItem: box.boxName, date: dateFormatter(date: Date()))
                                print(change.date)
                                modelContext.insert(change)
                                isShowingSelectionSheet = false
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingAddLocationSheet, content: {
                AddBoxLocationSheet(box: box, isSaved: $isSaved, activeTagArray: $activeTagArray, availableTagArray: $availableTagArray)
            })
            .alert(isPresented: $isShowingEmptyAlert) {
                Alert(title: Text("Cannot Leave Box Title Blank"), dismissButton: .default(Text("Ok")))
            }
        }
        
        func loadPhoto () {
            Task { @MainActor in
                box.photo = try await
                selectedItem?.loadTransferable(type: Data.self)
            }
        }
        
        func dateFormatter(date: Date) -> String{
            let date = date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "M/d/yy h:mm a"
            formatter.timeZone = TimeZone(abbreviation: "CST")!  // Set to CST time zone

            let formattedDate = formatter.string(from: date)
            return(formattedDate)
        }
        
    }
    
}

#Preview {
    ContentView()
}

