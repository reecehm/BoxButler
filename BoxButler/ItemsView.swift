//
//  MainView.swift
//  BoxButler
//
//  Created by 64014784 on 3/3/24.
//
import SwiftData
import SwiftUI

struct ItemsView: View {
    @Environment(\.modelContext) var modelContext
    @State private var isShowingFolderSheet = false
    @State private var itemPath = [Item]()
    @Query var folders: [Folder]
    
    var body: some View {
            ZStack {
                NavigationStack(path: $itemPath){
                        ItemsListView()
                            .navigationTitle("Box Butler")
                            .navigationDestination(for: Item.self) {item in EditItemView(item: item)}
                            .toolbar {
                                Button("Add Item", systemImage: "plus", action: addItem)
                            }
                        List {
                        ForEach(folders) { folder in
                            NavigationLink(value: folder) {
                                Text(folder.folderName)
                            }
                            }
                        }
                        .navigationDestination(for: Folder.self) {folder in EditFolderView(folder: folder)}
                    
                }
                .sheet(isPresented: $isShowingFolderSheet, content: {
                    addFolderSheet()
                })
                HStack {
                    Spacer()
                        .frame(width: 255)
                    VStack {
                        Spacer()
                            .frame(height: 600)
                            Button(action: { isShowingFolderSheet = true
                            }) {
                                Image(systemName: "folder")
                                    .frame(minWidth: 0, maxWidth: 40)
                                    .frame(minHeight: 0, maxHeight: 40)
                                    .font(.system(size: 18))
                                    .padding()
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            }
                            .background(Color.red.opacity(0.65))
                            .cornerRadius(25)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        
    }
    func addItem() {
        let item = Item(itemName: "", quantity: "", price: 0, folderName: "")
        modelContext.insert(item)
        itemPath.append(item)
    }
    
    struct addFolderSheet: View {
        @Environment(\.dismiss) private var dismiss
        @Environment(\.modelContext) var modelContext
        @State private var name: String = ""
        @Query var items: [Item]
        
        var body: some View {
            NavigationStack{
                Form {
                    Section{
                        TextField("Folder Name", text: $name)
                    }
                    Section("Select Items to Sort"){
                        ForEach(items) { item in
                                Text(item.itemName)
                        }
                    }
                }
                .navigationTitle("New Folder")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button("Cancel") {dismiss()}
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button("Save") {
                            let folder = Folder(folderName: name, items: [])
                            modelContext.insert(folder)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ItemsView()
}
