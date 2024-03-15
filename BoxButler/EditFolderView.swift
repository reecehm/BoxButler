//
//  EditFolderView.swift
//  BoxButler
//
//  Created by 64014784 on 3/11/24.
//
import SwiftData
import SwiftUI

struct EditFolderView: View {
    @Bindable var folder: Folder
    @Query var items: [Item]
    
    var body: some View {
        
            Form {
                Section ("Folder Name") {
                    TextField("Folder Name", text: $folder.folderName)
                }
                Section {
                        List{
                            ForEach(folder.contents!) { item in
                                NavigationLink(value: item) {
                                    Text(item.itemName)
                                    }
                            }
                        }
                }
            }
            .navigationTitle("Edit Folder")
        }
}
//#Preview {
//    EditPersonView()
//}

