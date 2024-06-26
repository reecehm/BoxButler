//
//  BoxButlerApp.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()
    return true

  }

}

class ScanState: ObservableObject{
    @Published var isScanning: Bool
    
    init(isScanning: Bool){
        self.isScanning = isScanning
    }
}

@main
struct BoxButlerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var scanState = ScanState(isScanning: false)
    @StateObject private var vm = AppViewModel()
    let modelContainer: ModelContainer
    
    init() {
            do {
                modelContainer = try ModelContainer(for: Item.self, Box.self, LocationTag.self, Change.self)
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
