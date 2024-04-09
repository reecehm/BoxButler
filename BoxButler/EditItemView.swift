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
    @Bindable var item: Item
    @Query var folders: [Folder]
    @State private var selectedItem: PhotosPickerItem?
    
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
                TextField("Price", value: $item.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                Picker("Folder", selection: $item.folderName) {
                    Text("None").tag("none")
                    ForEach(folders){ folder in
                        Text(folder.folderName).tag(folder.folderName)
                    }
                }
                .onReceive([self.item.folderName].publisher.first()) { folderName in
                    for folder in folders {
                        if folderName == folder.folderName{
                            folder.contents.append(item)
                        }
                    }
                    if folderName == "none" {
                        for folder in folders {
                            if folder.contents.contains(item){
                                folder.contents.remove(at: folder.contents.firstIndex(of: item)!)
                            }
                        }
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
