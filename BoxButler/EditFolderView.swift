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
    
    var body: some View {
        
        Form {
            Section {
                TextField("Folder Name", text: $folder.folderName)
            }
            Section {
                
            }

        }
        .navigationTitle("Edit Folder")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

//#Preview {
//    EditPersonView()
//}

