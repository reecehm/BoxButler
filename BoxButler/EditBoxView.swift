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
            }
        }
        .navigationTitle("Edit Box")
        .onChange(of: selectedItem, loadPhoto)
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
    }
}

//#Preview {
//    EditBoxView()
//}



