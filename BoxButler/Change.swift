//
//  Change.swift
//  BoxButler
//
//  Created by 64001174 on 4/22/24.
//

import Foundation
import SwiftData
@Model
class Change {
    var changeType: String
    var originalVar: String
    var newVar: String
    var nameOfChangedItem: String
    var date: String
    
    init(changeType: String, originalVar: String, newVar: String, nameOfChangedItem: String, date: String) {
        self.changeType = changeType
        self.originalVar = originalVar
        self.newVar = newVar
        self.nameOfChangedItem = nameOfChangedItem
        self.date = date        
    }
}
