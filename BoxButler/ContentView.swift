//
//  ContentView.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//
import SwiftData
import SwiftUI




struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = [Item]()
    @Query var items: [Item]
    @EnvironmentObject var scanState: ScanState
    
    var body: some View {
        NavigationView {
            TabView{
                HomeView()
                    .tabItem{
                        Image(systemName: "house.fill")
                            .foregroundColor(Color.white)
                        Text("Home")
                            .foregroundColor(Color.white)
                    }
                ShelfView()
                    .tabItem{
                        Image(systemName: "shippingbox")
                        Text("Shelf")
                    }
                SearchView()
                    .tabItem{
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                ScannerView()
                    .tabItem{
                        Image(systemName: "barcode.viewfinder")
                        Text("Scan")
                    }
                SettingsView()
                    .tabItem{
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                
            }
        }
    }
}

#Preview {
    ContentView()
}

