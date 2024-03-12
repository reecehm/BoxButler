//
//  Folder.swift
//  BoxButler
//
//  Created by 64014784 on 3/11/24.
//

import Foundation
import SwiftData

@Model
class Folder {
    var folderName: String
    var items: [Item]
    
    init(folderName: String, items: [Item]) {
        self.folderName = folderName
        self.items = items
    }
}
