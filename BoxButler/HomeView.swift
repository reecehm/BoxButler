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
    let otherBlueColor = Color(red: 65/255, green: 105/255, blue: 225/255)
    let tanColorUI = UIColor(red: 0.6784313725490196, green: 0.5098039215686274, blue: 0.4392156862745098, alpha: 1.0)
    let blueColor = UIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1.0)
    let redColor = UIColor(red: 196/255, green: 30/255, blue: 58/255, alpha: 1.0)
    let greenColor = UIColor(red: 22/255, green: 141/255, blue: 115/255, alpha: 1.0)
    @State var totalQuantity:Int = 0
    @State var totalInventoryValue: Decimal = 0.0
    @State var filteredItems: [Item] = []
    @Binding var notificationCount: String
    @State private var animate = false
    
    var body: some View {
        VStack{
            HStack{
                Image("logo")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("BoxButler")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 40, weight: .bold))
            }
            .background{UnevenRoundedRectangle(cornerRadii: .init(
                topLeading: animate ? 10.0 : 80.0,
                bottomLeading: animate ? 80.0 : 10.0,
                bottomTrailing: animate ? 80.0 : 10.0,
                topTrailing: animate ? 10.0 : 80.0))
            .foregroundStyle(.indigo)
            .frame(width: 400, height: 204)
            .padding()
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
                    if filteredItems.isEmpty {
                        HStack{
                            ZStack{
                                Image(systemName: "bell.and.waves.left.and.right.fill")
                                    .font(.system(size: 40))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                    .bold()
                                    .opacity(0.09)
                                    .foregroundColor(Color("TextColor"))
                                VStack{
                                    Text("No Notifications")
                                        .foregroundColor(Color("TextColor"))
                                }
                            }
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("NotificationColor"))
                                .padding(.vertical, 4)
                        )
                        .listRowSeparator(.hidden)
                    }
                    else{
                        ForEach(filteredItems, id: \.id) { item in
                            if item.quantityWarn != "" && item.quantity <= item.quantityWarn {
                                Text(item.itemName + " has low quantity.")
                                    .padding(.top, 8)
                                    .padding(.bottom, 8)
                            }
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("NotificationColor"))
                                .padding(.vertical, 4)
                        )
                        .listRowSeparator(.hidden)
                    }
                }
                .headerProminence(.increased)
                Section("Recent Changes"){
                    if changes.isEmpty {
                        ZStack{
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: 90))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .bold()
                                .opacity(0.06)
                                .foregroundColor(Color("TextColor"))
                            VStack{
                                Text("Start adding items to see their")
                                    .foregroundColor(Color("TextColor"))
                                Text("recent changes here!")
                                    .foregroundColor(Color("TextColor"))
                            }
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.white))
                                .padding(.vertical, 4)
                        )
                        .listRowSeparator(.hidden)
                    }
                    else{
                        ForEach(changes.reversed()) { change in
                            VStack{
                                HStack{
                                    Text(dateFormatter(dateAndTime: change.date))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(timeFormatter(dateAndTime: change.date))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Text(changeFormatter(change: change))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("NotificationColor"))
                                .padding(.vertical, 4)
                        )
                        .listRowSeparator(.hidden)
                        .onAppear {
                            filteredItems = items.filter {$0.quantity <= $0.quantityWarn }
                        }
                    }
                }
                .headerProminence(.increased)
            }
            .onAppear {
                filteredItems = items.filter { item in
                    if item.quantityWarn != "" && item.quantity != "" {
                        return item.quantity <= item.quantityWarn
                    }
                    return false // If quantityWarn is not set, exclude the item
                }
                print(filteredItems.count)
                if filteredItems.isEmpty{
                    notificationCount = ""
                }
                else{
                    notificationCount = String(filteredItems.count)
                }
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
                        item.quantity = "0"
                    }
                }
            }
        }
    }
    
    func changeFormatter (change: Change) -> AttributedString{
        var string = ""
        var finalAttributedString = NSMutableAttributedString()
        if change.changeType == "Removed Tag"{
            string = (change.changeType + " " + change.originalVar + " from " + change.nameOfChangedItem)
            let attributedString = NSMutableAttributedString(string: string)
            attributedString.addAttribute(.foregroundColor, value: blueColor, range: NSRange(location: 0, length: change.changeType.count))
            attributedString.addAttribute(.foregroundColor, value: redColor, range: NSRange(location: change.changeType.count+1, length: change.originalVar.count))
            attributedString.addAttribute(.foregroundColor, value: greenColor, range: NSRange(location: change.changeType.count + change.originalVar.count + 7, length: change.nameOfChangedItem.count))
            finalAttributedString = attributedString
        }
        else if change.changeType == "Added Tag"{
            string = (change.changeType + " " + change.newVar + " to " + change.nameOfChangedItem)
            let attributedString = NSMutableAttributedString(string: string)
            attributedString.addAttribute(.foregroundColor, value: blueColor, range: NSRange(location: 0, length: change.changeType.count))
            attributedString.addAttribute(.foregroundColor, value: greenColor, range: NSRange(location: change.changeType.count+1, length: change.newVar.count))
            attributedString.addAttribute(.foregroundColor, value: redColor, range: NSRange(location: change.changeType.count + change.newVar.count + 5, length: change.nameOfChangedItem.count))
            finalAttributedString = attributedString
        }
        else if change.changeType == "Photo"{
            string = (change.changeType + " for " + change.nameOfChangedItem + " was changed.")
            let attributedString = NSMutableAttributedString(string: string)
            attributedString.addAttribute(.foregroundColor, value: blueColor, range: NSRange(location: 0, length: change.changeType.count))
            attributedString.addAttribute(.foregroundColor, value: greenColor, range: NSRange(location: change.changeType.count+5, length: change.nameOfChangedItem.count))
            finalAttributedString = attributedString
        }
        else if change.changeType == "New item created" || change.changeType == "New box created" || change.changeType == "Item deleted" || change.changeType == "Box deleted"{
            string = (change.changeType + " named " + change.nameOfChangedItem + ".")
            let attributedString = NSMutableAttributedString(string: string)
            attributedString.addAttribute(.foregroundColor, value: blueColor, range: NSRange(location: 0, length: change.changeType.count))
            attributedString.addAttribute(.foregroundColor, value: greenColor, range: NSRange(location: change.changeType.count+7, length: change.nameOfChangedItem.count))
            finalAttributedString = attributedString
        }
        else{
            string = (change.changeType + " for " + change.nameOfChangedItem + " changed from " + change.originalVar + " to " + change.newVar)
            let attributedString = NSMutableAttributedString(string: string)
            attributedString.addAttribute(.foregroundColor, value: blueColor, range: NSRange(location: 0, length: change.changeType.count))
            attributedString.addAttribute(.foregroundColor, value: greenColor, range: NSRange(location: change.changeType.count+5, length: change.nameOfChangedItem.count))
            attributedString.addAttribute(.foregroundColor, value: redColor, range: NSRange(location: change.changeType.count + change.nameOfChangedItem.count+19, length: change.originalVar.count))
            attributedString.addAttribute(.foregroundColor, value: greenColor, range: NSRange(location: change.changeType.count + change.nameOfChangedItem.count+change.originalVar.count + 23, length: change.newVar.count))
            finalAttributedString = attributedString
        }
        return AttributedString(finalAttributedString)
    }
    
    func dateFormatter (dateAndTime: String) -> String{
        var date = ""
        date = String(dateAndTime.dropLast(9))
        return date
    }
    func timeFormatter (dateAndTime: String) -> String{
        var time = ""
        time = String(dateAndTime.dropFirst(8))
        return time
    }
    
    
}
//#Preview {
//    HomeView()
//}
