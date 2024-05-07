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
    var boxQuantity: String
    var price: Decimal = 0.0
    var boxDetails: String
    var location: [LocationTag] = []
    @Attribute(.externalStorage) var photo: Data?
    
    init(boxName: String, boxQuantity: String, price: Decimal = 0.0, boxDetails: String, location: [LocationTag]) {
        self.boxName = boxName
        self.boxQuantity = boxQuantity
        self.price = price
        self.boxDetails = boxDetails
        self.location = location
        self.photo = photo
    }
}
