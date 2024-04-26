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
    @Query var changes: [Change]
    @State var originalItem: Item = Item(itemName: "", quantity: "", itemDetails: "", location: [], quantityWarn: "")
    
    var body: some View {
            List {
                ForEach(items) { item in
                    VStack{
                        NavigationLink(value: item){
                            HStack{
                                Image(systemName: "pencil")
                                Text(item.itemName)
                                    .font(.system(size: 20, weight: .bold))
                                Spacer()
                                if let imageData = item.photo, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                        .overlay(
                                            Rectangle().stroke(Color.primary, lineWidth: 3)
                                                .cornerRadius(5)
                                        )
                                        .shadow(radius: 3)
                                }
                            }
                            }
                            .onTapGesture {originalItem = item}
                            ForEach(item.location) { tag in
                            HStack{
                                Text(tag.name)
                                    .foregroundColor(Color.white)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .frame(height: 27)
                                    .background(Rectangle().fill(Color(.red))
                                        .opacity(0.8))
                                    .cornerRadius(10)
                                Spacer()
                                }
                            }
                        
                    }
                    
                }
                .onDelete(perform: deleteItems)
                ForEach(boxes) { box in
                    VStack{
                        NavigationLink(value: box){
                            HStack{
                                Image(systemName: "shippingbox.fill")
                                Text(box.boxName)
                                    .font(.system(size: 20, weight: .bold))
                                Spacer()
                                if let imageData = box.photo, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                        .overlay(
                                            Rectangle().stroke(Color.primary, lineWidth: 3)
                                                .cornerRadius(5)
                                        )
                                        .shadow(radius: 3)
                                }
                            }
                            
                        }
                        ForEach(box.location) { tag in
                        HStack{
                            Text(tag.name)
                                .foregroundColor(Color.white)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(height: 27)
                                .background(Rectangle().fill(Color(.red))
                                    .opacity(0.8))
                                .cornerRadius(10)
                            Spacer()
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBoxes)
               
            }
           .onAppear{
                print("on appear")
                
                if newItemVar.newItem.itemName != originalItem.itemName {
                       let change = Change(changeType: "Item Name", changeMessage: "Item name changed from \(originalItem.itemName) to \(newItemVar.newItem.itemName)")
                    modelContext.insert(change)
                    print(change.changeMessage)
                }
                if newItemVar.newItem.quantity != originalItem.quantity {
                    let change = Change(changeType: "Quantity", changeMessage: "Quantity for \(newItemVar.newItem.itemName) changed from \(originalItem.quantity) to \(newItemVar.newItem.quantity)")
                    modelContext.insert(change)
                }
                if newItemVar.newItem.price != originalItem.price {
                    let change = Change(changeType: "Price", changeMessage: "Price for \(newItemVar.newItem.price) changed from \(originalItem.price) to \(newItemVar.newItem.price)")
                    modelContext.insert(change)
                }
                if newItemVar.newItem.itemDetails != originalItem.itemDetails {
                    let change = Change(changeType: "Item Details", changeMessage: "Item details for \(newItemVar.newItem.itemName) changed from \(originalItem.itemDetails) to \(newItemVar.newItem.itemDetails)")
                    modelContext.insert(change)
                }
                if newItemVar.newItem.location != originalItem.location {
                       let change = Change(changeType: "Location", changeMessage: "Item location for \(newItemVar.newItem.location) changed from \(originalItem.location) to \(newItemVar.newItem.location)")
                    modelContext.insert(change)
                }
                if newItemVar.newItem.quantityWarn != originalItem.quantityWarn {
                       let change = Change(changeType: "Quantity Warn", changeMessage: "Quantity warning threshold for \(newItemVar.newItem.itemName) changed from \(originalItem.quantityWarn) to \(newItemVar.newItem.quantityWarn)")
                    modelContext.insert(change)
                }
                if newItemVar.newItem.photo != originalItem.photo {
                       let change = Change(changeType: "Photo", changeMessage: "Photo for \(newItemVar.newItem.itemName) was changed.")
                       modelContext.insert(change)
                }
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
