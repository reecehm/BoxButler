//
//  Person.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//

import Foundation
import SwiftData

@Model
class Item {
    var name: String
    var emailAddress: String
    var details: String
    
    init(name: String, emailAddress: String, details: String) {
        self.name = name
        self.emailAddress = emailAddress
        self.details = details
    }
}
