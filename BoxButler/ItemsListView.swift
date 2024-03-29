//
//  ListsView.swift
//  BoxButler
//
//  Created by 64014784 on 3/7/24.
//
import SwiftData
import SwiftUI

extension String {
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
}

struct ItemsListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var items: [Item]
    @Query var folders: [Folder]

    
    var body: some View {
        if !items.isEmpty || !folders.isEmpty {
            Text("Swipe left to delete items.")
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.leading)
                .padding(.leading, -165.0)
                .padding(.top, 2)
            }
            List {
                ForEach(items) { item in
                    let decimalString = "\(item.price)"
                    if itemInFolder(item: item) == false {
                        NavigationLink(value: item) {
                            HStack{
                                Text(item.itemName)
                                Spacer()
                                Text(decimalString.currencyFormatting())
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
                ForEach(folders) { folder in
                    NavigationLink(value: folder) {
                        Image(systemName: "folder.fill")
                        Text(folder.folderName)
                        }
                    }
                .onDelete(perform: deleteFolders)
            }
            .overlay{
                if items.isEmpty && folders.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Items", systemImage: "circle.grid.3x3.fill")
                    }, description: {
                        Text("Click the plus to add items.")
                    })
                }
            }

    }
    init(searchString: String = "") {
        _items = Query(filter: #Predicate { item in
            if searchString.isEmpty {
                true
            } else {
                item.itemName.localizedStandardContains(searchString)
            }
        })
        _folders = Query(filter: #Predicate { item in
            if searchString.isEmpty {
                true
            } else {
                item.folderName.localizedStandardContains(searchString)
            }
        })
    }
    
    func deleteItems(at offsets: IndexSet) {
        for offsets in offsets {
            let item = items[offsets]
            modelContext.delete(item)
        }
    }
    func deleteFolders(at offsets: IndexSet) {
        for offsets in offsets {
            let folder = folders[offsets]
            modelContext.delete(folder)
        }
    }
    
    func itemInFolder(item: Item) -> Bool{
        for Folder in folders{
            for Item in Folder.contents{
                if Item == item {
                    return true
                }
            }
        }
        return false
    }
}


#Preview {
    ItemsListView()
}
