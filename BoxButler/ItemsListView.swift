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
    @Query var tags: [LocationTag]
    
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
                    ForEach(item.location) { tag in
                        HStack{
                            Text(tag.name)
                                .foregroundColor(Color.white)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(height: 27)
                                .background(Rectangle().fill(Color("AccentColor")))
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
                                    .background(Rectangle().fill(Color("AccentColor")))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                    }
                }
            .onDelete(perform: deleteBoxes)
            }
            .padding(.bottom, -10)
        }
        
    
    init(searchString: String = "", selectedTag: String) {
            _items = Query(filter: #Predicate { item in
                (searchString.isEmpty || item.itemName.localizedStandardContains(searchString)) &&
                (selectedTag == "" || item.location.contains { $0.name == selectedTag })
            })
            
            _boxes = Query(filter: #Predicate { box in
                searchString.isEmpty || box.boxName.localizedStandardContains(searchString)
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

struct itemStruct {
    static var originalItem: Item = Item(itemName: "", quantity: "", itemDetails: "", location: [], quantityWarn: "")
    static var locationTagName: [String] = []
}

struct boxStruct {
    static var originalBox: Box = Box(boxName: "", boxQuantity: "", boxDetails: "", location: [])
    static var locationTagName: [String] = []
}


//#Preview {
//    ItemsListView()
//}
