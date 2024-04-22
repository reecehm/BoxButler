//
//  BoxButlerApp.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//

import SwiftUI
import SwiftData

class ScanState: ObservableObject{
    @Published var isScanning: Bool
    
    init(isScanning: Bool){
        self.isScanning = isScanning
    }
}

@main
struct BoxButlerApp: App {
    @ObservedObject var scanState = ScanState(isScanning: false)
    @StateObject private var vm = AppViewModel()
    let modelContainer: ModelContainer
    
    init() {
            do {
                modelContainer = try ModelContainer(for: Item.self, Box.self, LocationTag.self)
            } catch {
                fatalError("Could not initialize ModelContainer")
            }
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(scanState)
                .environmentObject(vm)
                .task {
                    await vm.requestDataScannerAccessStatus()
                }
        }
        .modelContainer(modelContainer)
        
    }
}
