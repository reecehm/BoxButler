//
//  MainView.swift
//  BoxButler
//
//  Created by 64014784 on 3/3/24.
//
import SwiftData
import SwiftUI

struct ItemView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = [Item]()
    @Query var items: [Item]
    @State var isItems = false
    
    
    var body: some View {
        NavigationStack(path: $path){
            if items.count == 0 {
                VStack {
                    Text("There's no items in your list! Click the plus to add an item.")
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Rectangle()
                            .fill(Color(.gray)
                                .opacity(0.13))
                                .cornerRadius(12))
                }
                List {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            Text(item.itemName)
                        }
                    }
                    .onDelete(perform: deletePeople)
                }
                .navigationTitle("Box Butler")
                .navigationDestination(for: Item.self)
                {item in
                    EditItemView(item: item)
                }
                .toolbar {
                    Button("Add Item", systemImage: "plus", action: addItem)
                }
            }
            else {
                HStack {
                    Text("Swipe left on items to delete")
                        .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                    Spacer()
                }
                List {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            Text(item.itemName)
                        }
                    }
                    .onDelete(perform: deletePeople)
                }
                .navigationTitle("Box Butler")
                .navigationDestination(for: Item.self)
                {item in
                    EditItemView(item: item)
                }
                .toolbar {
                    Button("Add Item", systemImage: "plus", action: addItem)
                }
            }
        }
    }
    
    func addItem() {
        let item = Item(itemName: "", quantity: "", price: 0, folderName: "")
        modelContext.insert(item)
        path.append(item)
    }
    
    func deletePeople(at offsets: IndexSet) {
        for offsets in offsets {
            let item = items[offsets]
            modelContext.delete(item)
        }
    }
}

#Preview {
    ItemView()
}
