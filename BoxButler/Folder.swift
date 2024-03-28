//
//  Folder.swift
//  BoxButler
//
//  Created by 64014784 on 3/11/24.
//

import Foundation
import SwiftData

@Model
class Folder: Hashable, Identifiable {
    let id = UUID()
    var folderName: String
    var contents: [Item] = []
    
    init(folderName: String, contents: [Item] = [], id: UUID) {
        self.folderName = folderName
        self.contents = contents
        self.id = id
    }
}
