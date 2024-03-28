//
//  Person.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//

import Foundation
import SwiftData

@Model
class Item: Hashable, Equatable {
    var itemName: String
    var quantity: String
    var price: Decimal = 0.0
    var folderName: String
    var selected = 0
    
    init(itemName: String, quantity: String, price: Decimal = 0.0, folderName: String, selected: Int) {
        self.itemName = itemName
        self.quantity = quantity
        self.price = price
        self.folderName = folderName
        self.selected = selected
    }
}
