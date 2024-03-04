//
//  MainView.swift
//  BoxButler
//
//  Created by 64014784 on 3/3/24.
//
import SwiftData
import SwiftUI

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = [Item]()
    @Query var items: [Item]
    
    var body: some View {
        NavigationStack(path: $path){
            List {
                ForEach(items) { item in
                    NavigationLink(value: item) {
                        Text(item.name)
                    }
                }
            }
            .navigationTitle("Box Butler")
            .navigationDestination(for: Item.self) {item in
                EditItemView(item: item)
            }
            .toolbar {
                Button("Add Person", systemImage: "plus", action: addItem)
            }
        }    }
    
    func addItem() {
        let item = Item(name: "", emailAddress: "", details: "")
        modelContext.insert(item)
        path.append(item)
    }
}

#Preview {
    MainView()
}
