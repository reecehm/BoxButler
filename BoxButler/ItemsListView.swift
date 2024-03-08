//
//  ListsView.swift
//  BoxButler
//
//  Created by 64014784 on 3/7/24.
//
import SwiftData
import SwiftUI

struct ItemsListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var items: [Item]
    
    var body: some View {
        if items.isEmpty == true{
            VStack {
                Text("There's no items in your list! Click the plus to add an item.")
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Rectangle()
                        .fill(Color(.gray)
                            .opacity(0.13))
                            .cornerRadius(12))
                Spacer()
            }
        }
        else {
            Text("Swipe left to delete items.")
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.leading)
                .padding(.leading)
            List {
                ForEach(items) { item in
                    NavigationLink(value: item) {
                        Text(item.itemName)
                    }
                }
                    .onDelete(perform: deletePeople)
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
    }
    
    func deletePeople(at offsets: IndexSet) {
        for offsets in offsets {
            let item = items[offsets]
            modelContext.delete(item)
        }
    }
}

#Preview {
    ItemsListView()
}
