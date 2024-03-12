//
//  BoxButlerApp.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//

import SwiftUI
import SwiftData

@main
struct BoxButlerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // This is a comment
        .modelContainer(for: [Item.self, Folder.self])
    }
}
