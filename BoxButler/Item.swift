//
//  Person.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//

import Foundation
import SwiftData

@Model
class Item: Hashable {
    var itemName: String
    var quantity: String
    var price: Double
    var folderName: String
    var selected = 0
    
    init(itemName: String, quantity: String, price: Double, folderName: String, selected: Int) {
        self.itemName = itemName
        self.quantity = quantity
        self.price = price
        self.folderName = folderName
        self.selected = selected
    }
}
