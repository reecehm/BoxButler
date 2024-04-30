//
//  EditPersonView.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//
import PhotosUI
import SwiftData
import SwiftUI

struct EditItemView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var item: Item
    @Query var boxes: [Box]
    
    @State private var selectedItem: PhotosPickerItem?
    @Binding var isShowingAddLocationSheet: Bool
    @Binding var shouldShowPlus: Bool
    @Query var changes: [Change]
    

    var body: some View {
        
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
                        Text("Edit Tags")
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                ForEach(item.location) { tag in
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
        .onChange(of: selectedItem, loadPhoto)
        .onAppear{
            shouldShowPlus = true
                itemStruct.originalItem.itemName = item.itemName
                itemStruct.originalItem.quantity = item.quantity
                itemStruct.originalItem.price = item.price  
                itemStruct.originalItem.itemDetails = item.itemDetails
                for location in item.location {
                itemStruct.locationTagName.append(location.name)
                }
                itemStruct.originalItem.quantityWarn = item.quantityWarn
        }
        .onDisappear{
            if item.itemName != itemStruct.originalItem.itemName && !itemStruct.originalItem.itemName.isEmpty {
                let change = Change(changeType: "Item Name", originalVar: itemStruct.originalItem.itemName, newVar: item.itemName, nameOfChangedItem: itemStruct.originalItem.itemName)
                    modelContext.insert(change)
                 }
            if item.quantity != itemStruct.originalItem.quantity && !itemStruct.originalItem.quantity.isEmpty{
                let change = Change(changeType: "Quantity", originalVar: itemStruct.originalItem.quantity, newVar: item.quantity, nameOfChangedItem: itemStruct.originalItem.itemName)
                    modelContext.insert(change)
                 }
            if item.price != itemStruct.originalItem.price {
                let originalPriceString = String(describing: itemStruct.originalItem.price)
                let newPriceString = String(describing: item.price)
                let change = Change(changeType: "Price", originalVar: originalPriceString, newVar: newPriceString, nameOfChangedItem: item.itemName)
                modelContext.insert(change)
            }
            if item.itemDetails != itemStruct.originalItem.itemDetails && !itemStruct.originalItem.itemDetails.isEmpty {
                let change = Change(changeType: "Item Details", originalVar: itemStruct.originalItem.itemDetails, newVar: item.itemDetails, nameOfChangedItem: item.itemName)
                    modelContext.insert(change)
                 }
            if !item.location.isEmpty && itemStruct.locationTagName.isEmpty {
                for location in item.location {
                    let change = Change(changeType: "Added Tag", originalVar: "", newVar: location.name, nameOfChangedItem: item.itemName)
                            modelContext.insert(change)
                }
            }
            if item.location.isEmpty && !itemStruct.locationTagName.isEmpty {
                for name in itemStruct.locationTagName {
                    let change = Change(changeType: "Removed Tag", originalVar: name, newVar: "", nameOfChangedItem: item.itemName)
                        modelContext.insert(change)
                }
            }
            if item.location.count < itemStruct.locationTagName.count {
                for location in item.location {
                    for name in itemStruct.locationTagName {
                        if !location.name.contains(name) {
                            let change = Change(changeType: "Removed Tag", originalVar: name, newVar: "", nameOfChangedItem: item.itemName)
                                modelContext.insert(change)
                        }
                    }
                }
            }
            if item.location.count > itemStruct.locationTagName.count {
                for location in item.location {
                    for _ in itemStruct.locationTagName {
                        if !itemStruct.locationTagName.contains(location.name) {
                            let change = Change(changeType: "Added Tag", originalVar: "", newVar: location.name, nameOfChangedItem: item.itemName)
                                modelContext.insert(change)
                        }
                    }
                }
            }
            if item.quantityWarn != itemStruct.originalItem.quantityWarn && !itemStruct.originalItem.quantityWarn.isEmpty{
                let change = Change(changeType: "Quantity Warn", originalVar: itemStruct.originalItem.quantityWarn, newVar: item.quantityWarn, nameOfChangedItem: itemStruct.originalItem.itemName)
                    modelContext.insert(change)
                 }
            if item.photo != itemStruct.originalItem.photo {
                let change = Change(changeType: "Photo", originalVar: itemStruct.originalItem.itemName, newVar: item.itemName, nameOfChangedItem: item.itemName)
                    modelContext.insert(change)
                 }
             
        }
    }
        
    
    
    
    
    
    func loadPhoto () {
        Task { @MainActor in
            item.photo = try await
            selectedItem?.loadTransferable(type: Data.self)
        }
    }
    
}



//#Preview {
//    EditPersonView()
//}
