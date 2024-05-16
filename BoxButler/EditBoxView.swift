//
//  EditBoxView.swift
//  BoxButler
//
//  Created by 64014784 on 4/10/24.
//
import SwiftData
import SwiftUI
import PhotosUI

struct EditBoxView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var box: Box
    @Query var items: [Item]
    
    @State private var selectedItem: PhotosPickerItem?
    @Binding var isShowingAddLocationSheet: Bool
    @Binding var shouldShowPlus: Bool
    @Query var changes: [Change]

    
    var body: some View {
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
                    .keyboardType(.decimalPad)
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
                ForEach(box.location) { tag in
                    HStack{
                        Text(tag.name)
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(height: 27)
                            .background(Rectangle().fill(Color("AccentColor")))
                            .cornerRadius(10)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Edit Box")
        .onChange(of: selectedItem, loadPhoto)
        .onAppear{
            shouldShowPlus = true
            boxStruct.originalBox.boxName = box.boxName
            boxStruct.originalBox.boxQuantity = box.boxQuantity
            boxStruct.originalBox.price = box.price
            boxStruct.originalBox.boxDetails = box.boxDetails
            for location in box.location {
                boxStruct.locationTagName.append(location.name)
            }
        }
        .onDisappear{
            if box.boxName != boxStruct.originalBox.boxName && !boxStruct.originalBox.boxName.isEmpty {
                let change = Change(changeType: "Box Name", originalVar: boxStruct.originalBox.boxName, newVar: box.boxName, nameOfChangedItem: boxStruct.originalBox.boxName, date: Date().description)
                modelContext.insert(change)
            }
            if box.boxQuantity != boxStruct.originalBox.boxQuantity && !boxStruct.originalBox.boxQuantity.isEmpty {
                let change = Change(changeType: "Quantity", originalVar: boxStruct.originalBox.boxQuantity, newVar: box.boxQuantity, nameOfChangedItem: box.boxName, date: Date().description)
                modelContext.insert(change)
            }
            if box.price != boxStruct.originalBox.price {
                let originalPriceString = String(describing: boxStruct.originalBox.price)
                let newPriceString = String(describing: box.price)
                let change = Change(changeType: "Price", originalVar: originalPriceString, newVar: newPriceString, nameOfChangedItem: box.boxName, date: Date().description)
                modelContext.insert(change)
            }
            if box.boxDetails != boxStruct.originalBox.boxDetails && !boxStruct.originalBox.boxDetails.isEmpty {
                let change = Change(changeType: "Box Details", originalVar: boxStruct.originalBox.boxDetails, newVar: box.boxDetails, nameOfChangedItem: box.boxName, date: Date().description)
                modelContext.insert(change)
            }
            if box.location.count < boxStruct.locationTagName.count {
                var locationNames: [String] = []
                for location in box.location {
                    locationNames.append(location.name)
                }
                for name in boxStruct.locationTagName {
                    if !locationNames.contains(name) {
                        let change = Change(changeType: "Removed Tag", originalVar: name, newVar: "", nameOfChangedItem: box.boxName, date: Date().description)
                        modelContext.insert(change)
                    }
                }
            }
            if box.location.count > boxStruct.locationTagName.count {
                for location in box.location {
                    if !boxStruct.locationTagName.contains(location.name) {
                        let change = Change(changeType: "Added Tag", originalVar: "", newVar: location.name, nameOfChangedItem: box.boxName, date: Date().description)
                        modelContext.insert(change)
                    }
                }
            }
        
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for offsets in offsets {
            let item = items[offsets]
            modelContext.delete(item)
        }
    }
    
    func loadPhoto () {
        Task { @MainActor in
            box.photo = try await
            selectedItem?.loadTransferable(type: Data.self)
        }
        let change = Change(changeType: "Photo", originalVar: boxStruct.originalBox.boxName, newVar: box.boxName, nameOfChangedItem: box.boxName, date: Date().description)
        modelContext.insert(change)
    }
}

//#Preview {
//    EditBoxView()
//}



