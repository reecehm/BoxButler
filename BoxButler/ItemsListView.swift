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
    @Query var boxes: [Box]

    
    var body: some View {
        
            List {
                ForEach(items) { item in
                    NavigationLink(value: item){
                        Image(systemName: "pencil")
                        Text(item.itemName)
                    }
                }
                .onDelete(perform: deleteItems)
                ForEach(boxes) { box in
                    NavigationLink(value: box){
                        Image(systemName: "shippingbox.fill")
                        Text(box.boxName)
                    }
                }
                .onDelete(perform: deleteBoxes)
            }
        
            .overlay{
                if items.isEmpty && boxes.isEmpty{
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
    }
    
    func deleteItems(at offsets: IndexSet) {
        for offsets in offsets {
            let item = items[offsets]
            modelContext.delete(item)
        }
    }
    func deleteBoxes(at offsets: IndexSet) {
        for offsets in offsets {
            let box = boxes[offsets]
            modelContext.delete(box)
        }
    }
}


//#Preview {
//    ItemsListView()
//}
