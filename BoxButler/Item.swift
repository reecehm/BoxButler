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
    var itemDetails: String
    var location: [LocationTag] = []
    @Attribute(.externalStorage) var photo: Data?
    
    init(itemName: String, quantity: String, price: Decimal = 0.0, itemDetails: String, location: [LocationTag]) {
        self.itemName = itemName
        self.quantity = quantity
        self.price = price
        self.itemDetails = itemDetails
        self.location = location
    }
}
