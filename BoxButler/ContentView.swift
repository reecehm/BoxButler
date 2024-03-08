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
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ItemsView()
                .tabItem{
                    Image(systemName: "shippingbox")
                    Text("Items")
                }
            SearchView()
                .tabItem{
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            SettingsView()
                .tabItem{
                     Image(systemName: "gear")
                     Text("Settings")
                }
        }
    }
}

#Preview {
    ContentView()
}
