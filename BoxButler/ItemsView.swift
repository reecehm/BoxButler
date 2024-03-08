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
    @State private var itemPath = [Item]()
    
    var body: some View {
        NavigationView{
            ZStack {
                NavigationStack(path: $itemPath){
                    ItemsListView()
                        .navigationTitle("Box Butler")
                        .navigationDestination(for: Item.self) {item in EditItemView(item: item)}
                        .toolbar {
                            Button("Add Item", systemImage: "plus", action: addItem)
                        }
                }
                HStack {
                    Spacer()
                        .frame(width: 255)
                    VStack {
                        Spacer()
                            .frame(height: 600)
                            Button(action: {
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
    }
    func addItem() {
        let item = Item(itemName: "", quantity: "", price: 0, folderName: "")
        modelContext.insert(item)
        itemPath.append(item)
    }

}

#Preview {
    ItemsView()
}
