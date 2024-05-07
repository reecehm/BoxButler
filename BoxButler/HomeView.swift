//
//  Home Screen.swift
//  BoxButler
//
//  Created by 64014784 on 3/5/24.
//
import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query var items: [Item]
    @Query var boxes: [Box]
    @Query var changes: [Change]
    let tanColor = Color(red: 0.6784313725490196, green: 0.5098039215686274, blue: 0.4392156862745098)
    let blueColor = UIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1.0)
    @State var totalQuantity:Int = 0
    @State var totalInventoryValue: Decimal = 0.0
    @State var filteredItems: [Item] = []

    var body: some View {
        VStack{
            ZStack {
                HStack{
                    Spacer()
                    Text("Not in an Organization? Click here to join a group.")
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 230, height: 88)
                        .background(Rectangle().fill(.thinMaterial))
                        .cornerRadius(10)
                    Spacer()
                    VStack{
                        Text("Username")
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(width: 120
                                   , height: 40
                            )
                            .background(Rectangle().fill(Color(tanColor)))
                            .cornerRadius(10)
                        Text("Group")
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(width: 120
                                   , height: 40
                            )
                            .background(Rectangle().fill(Color(tanColor)))
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
            HStack {
                Divider()
                VStack {
                    Text("Items")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text(String(items.count))
                }
                Divider()
                VStack {
                    Text("Boxes")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text(String(boxes.count))
                }
                Divider()
                VStack {
                    Text("Total Quantity In Inventory")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text(String(totalQuantity))
                }
                Divider()
                VStack {
                    Text("Total Value In Inventory")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text("$" + "\(String(describing: totalInventoryValue))")
                }
                Divider()
            }
            .frame(height: 88)
            .background(Rectangle().fill(.thinMaterial))
            .cornerRadius(10)
            Divider()
                .frame(height: 0.8)
                .overlay(.gray)
                .opacity(0.5)
            List {
                Section("Notifications") {
                    ForEach(filteredItems, id: \.id) { item in
                        if item.quantityWarn != "" && item.quantity <= item.quantityWarn {
                                Text(item.itemName + " has low quantity.")
                                .padding(.top, 8)
                                .padding(.bottom, 8)
                        }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                          .fill(Color(.white))
                          .padding(.vertical, 4)
                    )
                    .listRowSeparator(.hidden)
                    .overlay(Group{
                        if filteredItems.isEmpty {
                            HStack{
                                Text("No notifications")
                                Image(systemName: "bell.and.waves.left.and.right.fill")
                            }
                    }})
                }
                .headerProminence(.increased)
                .onAppear {
                    filteredItems = items.filter { item in
                        if item.quantityWarn != "" {
                            return item.quantity <= item.quantityWarn
                        }
                        return false // If quantityWarn is not set, exclude the item
                    }
                }
                Section("Recent Changes"){
                        ForEach(changes.reversed()) { change in
                            if change.changeType == "Removed Tag"{
                                Text(stringFormatter(change: change))
                            }
                            else if change.changeType == "Added Tag" {
                                VStack{
                                    HStack{
                                        Text(change.changeType)
                                            .foregroundColor(.blue)
                                        Text(change.newVar)
                                        
                                        Spacer()
                                    }
                                    HStack{
                                        Text("to")
                                        Text(change.nameOfChangedItem)
                                        Spacer()
                                    }
                                }
                            }
                            else if change.changeType == "Photo"{
                                Text("\(change.changeType) for \(change.originalVar) was changed.")
                            }
                            else if change.changeType == "New item created" {
                                Text("\(change.changeType) named \(change.newVar).")
                            }
                            else if change.changeType == "New box created" {
                                Text("\(change.changeType) named \(change.newVar).")
                            }
                            else {
                                VStack {
                                    HStack {
                                        Text(change.changeType)
                                            .foregroundColor(.blue)
                                        Text("for")
                                        Text(change.nameOfChangedItem)
                                        
                                        Spacer()
                                    }
                                    HStack {
                                        Text("changed from")
                                        Text(change.originalVar)
                                            .foregroundColor(.red)
                                        
                                        Spacer()
                                    }
                                    HStack{
                                        Text("to")
                                            .multilineTextAlignment(.leading)
                                        Text(change.newVar)
                                            .foregroundColor(.green)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                              .fill(Color(.white))
                              .padding(.vertical, 4)
                        )
                        .listRowSeparator(.hidden)
                        .onAppear {
                            filteredItems = items.filter {$0.quantity <= $0.quantityWarn }
                        }
                    }
                .headerProminence(.increased)
                    .overlay(Group{
                        if changes.isEmpty {
                            HStack{
                                VStack{
                                    Text("Start adding items to see their")
                                    Text("recent changes here!")
                                    Image(systemName: "list.bullet.rectangle")
                                        .padding(.top, 2)
                                        .bold()
                                }
                            }
                        }})
                
            }
            .padding(.top, -8)
            .onAppear {
                totalQuantity = 0
                totalInventoryValue = 0
                
                for item in items {
                    if let quantity = Int(item.quantity) {
                        totalQuantity += quantity
                        totalInventoryValue += Decimal(quantity) * item.price
                    } else {
                        print("Invalid quantity value for item: \(item)")
                    }
                }
            }
        }
    }
    
    func stringFormatter (change: Change) -> AttributedString{
                let string = (change.changeType + " " + change.originalVar + " from " + change.nameOfChangedItem)
                let attributedString = NSMutableAttributedString(string: string)
                attributedString.addAttribute(.foregroundColor, value: blueColor, range: NSRange(location: 0, length: change.changeType.count))
                attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: change.changeType.count+1, length: change.originalVar.count))
                attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: change.changeType.count + change.originalVar.count+2, length: 4))
                attributedString.addAttribute(.foregroundColor, value: UIColor.green, range: NSRange(location: change.changeType.count + change.originalVar.count + 7, length: change.nameOfChangedItem.count))
                
                return AttributedString(attributedString)
        }
    
}
#Preview {
    HomeView()
}
