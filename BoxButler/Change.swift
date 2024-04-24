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
    var oldVar: String
    var newVar: String
    var whereString: String
    var changeMessage: String
    
    init(changeType: String, oldVar: String, newVar: String, whereString: String, changeMessage: String) {
        self.changeType = changeType
        self.oldVar = oldVar
        self.newVar = newVar
        self.whereString = whereString
        self.changeMessage = changeMessage
    }
}
