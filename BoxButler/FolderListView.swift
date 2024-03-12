//
//  FolderView.swift
//  BoxButler
//
//  Created by 64014784 on 3/11/24.
//
import SwiftData
import SwiftUI

struct FolderListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var folders: [Folder]
    
    var body: some View {
            List {
                ForEach(folders) { folder in
                    NavigationLink(value: folder) {
                        Text(folder.folderName)
                    }
                }
            }
    }
}


#Preview {
    ItemsListView()
}
