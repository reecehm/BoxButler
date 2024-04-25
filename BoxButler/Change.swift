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
    var changeMessage: String
    
    init(changeType: String, changeMessage: String) {
        self.changeType = changeType
        self.changeMessage = changeMessage
    }
}
