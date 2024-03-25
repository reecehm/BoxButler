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
    @State private var navPath = NavigationPath()
    @Query var folders: [Folder]
    @Query var items: [Item]
    
    var body: some View {
            ZStack {
                    NavigationStack(path: $navPath){
                            ItemsListView()
                                .navigationDestination(for: Item.self) {item in EditItemView(item: item)}
                                .navigationDestination(for: Folder.self) {folder in EditFolderView(folder: folder)
                                        .toolbar {
                                            ToolbarItemGroup(placement: .topBarTrailing) {
                                                Button("Add Item", systemImage: "plus", action:{
                                                    addFolderItem(folder: folder)
                                                }
                                                )
                                            }
                                        }
                                }
                                .toolbar {
                                    Button("Add Item", systemImage: "plus", action: addItem)
                                }
                    }
                    .navigationTitle("Box Butler")
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
                                for item in items {
                                    item.selected = 0
                                    }
                            }) {
                                Image(systemName: "folder.badge.plus")
                                    .frame(minWidth: 0, maxWidth: 40)
                                    .frame(minHeight: 0, maxHeight: 40)
                                    .font(.system(size: 18))
                                    .padding()
                                    .foregroundColor(.white)

                            }
                            .background(Color.red.opacity(0.65))
                            .cornerRadius(25)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        
    }
    func addItem() {
        let item = Item(itemName: "", quantity: "", price: 0, folderName: "", selected: 0)
        modelContext.insert(item)
        navPath.append(item)
    }
    
    func addFolderItem(folder: Folder){
        let item = Item(itemName: "", quantity: "", price: 0, folderName: "", selected: 0)
        folder.contents!.append(item)
        navPath.append(item)
    }
    
    struct addFolderSheet: View {
        @Environment(\.dismiss) private var dismiss
        @Environment(\.modelContext) var modelContext
        @State private var assigning: [Item] = []
        @State private var name: String = ""
        @State var index: Int = 0
        @Query var items: [Item]
        
        
    var body: some View {
        NavigationStack{
            Form {
                Section{
                    TextField("Folder Name", text: $name)
                }
                Section("Select Items to Sort"){
                    List{
                        ForEach(items) { item in
                            
                            Button(action: {
                                if item.selected == 0 {
                                    item.selected = 1
                                    assigning.append(item)
                                }
                                else {
                                    item.selected = 0
                                    index = assigning.firstIndex(of: item)!
                                    assigning.remove(at : index)
                                    
                                }
                            }) {
                                HStack{
                                    Text(item.itemName)
                                    if !assigning.isEmpty && assigning.contains(item) == true {
                                        Image(systemName: "checkmark")
                                        .foregroundColor(.blue)}
                                    else{
                                        Image(systemName: "checkmark")
                                            .opacity(0.0)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Folder")
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {for item in items {
                        item.selected = 0
                        }
                        dismiss()}
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button{
                        let folder = Folder(folderName: name, contents: assigning, id: UUID())
                            modelContext.insert(folder)
                            for item in assigning {
                                item.folderName = folder.folderName
                            }
                            for item in items {
                                item.selected = 0
                            }
                            dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
    }
    
    func itemExists(item: Item) -> Bool{
        for Folder in folders{
            for Item in Folder.contents!{
                if Item == item {
                    return true
                }
            }
        }
        return false
    }
}


#Preview {
    ItemsView()
}
