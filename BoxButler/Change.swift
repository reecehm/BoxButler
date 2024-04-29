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
    
    init(changeType: String, originalVar: String, newVar: String) {
        self.changeType = changeType
        self.originalVar = originalVar
        self.newVar = newVar
        
        
    }
}
