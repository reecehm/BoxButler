//
//  Folder.swift
//  BoxButler
//
//  Created by 64014784 on 3/11/24.
//

import Foundation
import SwiftData

@Model
class Box: Hashable, Identifiable {
    var boxName: String
    var boxQuantity: Int
    var price: Decimal = 0.0
    var boxDetails: String
    var location: String
    @Attribute(.externalStorage) var photo: Data?
    
    init(boxName: String, boxQuantity: Int, price: Decimal, boxDetails: String, location: String) {
        self.boxName = boxName
        self.boxQuantity = boxQuantity
        self.price = price
        self.boxDetails = boxDetails
        self.location = location
        self.photo = photo
    }
}
