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
    
    let greyColor = Color(red: 0.9137, green: 0.9137, blue: 0.9215)
    
    @State var totalQuantity:Int = 0
    @State var totalInventoryValue: Decimal = 0.0
    @State  var filteredItems: [Item] = []

    
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
            HStack {
                VStack {
                    HStack {
                        Text("Notifications")
                            .font(.headline)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .frame(height: 35)
                            .background(Rectangle().fill(.thinMaterial))
                            .cornerRadius(10)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    List {
                            ForEach(filteredItems, id: \.id) { item in
                                    Text(item.itemName + " has low quantity.")
                            }
                            }
                    .onAppear {
                        filteredItems = items.filter {$0.quantity <= $0.quantityWarn }
                    }
                    HStack {
                        Text("Recent Changes")
                            .font(.headline)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .frame(height: 35)
                            .background(Rectangle().fill(.thinMaterial))
                            .cornerRadius(10)
                            .padding(.leading, 10)
                        
                        Spacer()
                    }
                    List {
                        ForEach(changes.reversed()) { change in
                            if change.changeType != "Photo" || change.changeType != "New item created" {
                                VStack {
                                    HStack {
                                        Text(change.changeType)
                                            .foregroundColor(.blue)
                                        Text("in item")
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
                            if change.changeType == "Location"{
                                VStack {
                                    HStack {
                                        Text(change.changeType)
                                            .foregroundColor(.blue)
                                        Text("changed from")
                                        Text(change.originalVar)
                                            .foregroundColor(.red)
                                        Spacer()
                                    }
                                    HStack {
                                        Text("to")
                                            .multilineTextAlignment(.leading)
                                        Text(change.newVar)
                                            .foregroundColor(.green)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                }
                            }
                            if change.changeType == "New item created"{
                                VStack {
                                    HStack {
                                        Text(change.changeType)
                                            .foregroundColor(.blue)
                                        Text("named")
                                        Text(change.newVar)
                                            .foregroundColor(.green)
                                        Spacer()
                                    }
                                }
                            }
                            else {
                                Text("\(change.changeType) for \(change.originalVar) was changed.")
                            }
                        }
                    }
                    
                    .onAppear {
                        filteredItems = items.filter {$0.quantity <= $0.quantityWarn }
                    }
                }
            }
            
        }
        .padding(.bottom, 40.0)
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

#Preview {
    HomeView()
}
