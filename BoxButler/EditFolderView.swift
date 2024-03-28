//
//  EditFolderView.swift
//  BoxButler
//
//  Created by 64014784 on 3/11/24.
//
import SwiftData
import SwiftUI

struct EditFolderView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var folder: Folder
    @Query var items: [Item]
    
    var body: some View {
        
            Form {
                Section ("Folder Name") {
                    TextField("Folder Name", text: $folder.folderName)
                }
                Section ("Folder Items"){
                        List{
                            ForEach(folder.contents) { item in
                                NavigationLink(value: item) {
                                    Text(item.itemName)
                                    }
                            }
                            .onDelete(perform: deleteItems)
                        }
                }
            }
            .navigationTitle("Edit Folder")
    }
    func deleteItems(at offsets: IndexSet) {
        for offsets in offsets {
            let item = items[offsets]
            modelContext.delete(item)
        }
    }
    
}


//#Preview {
//    EditPersonView()
//}

