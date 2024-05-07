//
//  SearchView.swift
//  BoxButler
//
//  Created by 64014784 on 3/7/24.
//
//
import SwiftData
import SwiftUI

struct SearchView: View {
    
    @State private var searchText = ""
    @Query var items: [Item]
    @Query var boxes: [Box]
    @State private var isShowingAddLocationSheet = false
    @State var shouldShowPlus: Bool = false
    
    @Binding var selectedTab: Tab
    
    var body: some View {
                NavigationStack{
                    ItemsListView(searchString: searchText)
                        .overlay{
                            if items.isEmpty && boxes.isEmpty{
                                ContentUnavailableView(label: {
                                    Label("No Items", systemImage: "circle.grid.3x3.fill")
                                })
                            }
                        }
                        .navigationTitle("Search")
                        .navigationDestination(for: Item.self) {item in EditItemView(item: item, isShowingAddLocationSheet: $isShowingAddLocationSheet, shouldShowPlus: $shouldShowPlus)
                                .sheet(isPresented: $isShowingAddLocationSheet, content: {
                                    AddItemLocationSheet(item: item)
                                })}
                        .navigationDestination(for: Box.self) {box in EditBoxView(box: box, isShowingAddLocationSheet: $isShowingAddLocationSheet, shouldShowPlus: $shouldShowPlus)
                                .sheet(isPresented: $isShowingAddLocationSheet, content: {
                                    AddBoxLocationSheet(box: box)
                                })}
                    tabBarView
                }
                .searchable(text: $searchText)
    }
    
    init(searchString: String = "", selectedTab: Binding<Tab>) {
        _items = Query(filter: #Predicate { item in
            true
        })
        _boxes = Query(filter: #Predicate { box in
            true
        })
        self._selectedTab = selectedTab
    }
    
    var tabBarView: some View {
        ZStack{
            VStack(spacing: 0) {
                Divider()
                    .frame(height: 0.8)
                    .overlay(.gray)
                    .opacity(0.5)
                HStack(spacing: 9) {
                    tabBarItem(.first, title: "Home", icon: "house", selectedIcon: "house.fill")
                    tabBarItem(.second, title: "Shelf", icon: "shippingbox", selectedIcon: "shippingbox.fill")
                    tabBarItem(.third, title: "Search", icon: "magnifyingglass", selectedIcon: "magnifyingglass")
                    tabBarItem(.fourth, title: "Scan", icon: "barcode.viewfinder", selectedIcon: "barcode.viewfinder")
                    tabBarItem(.fifth, title: "Settings", icon: "gear", selectedIcon: "gear")
                }
                .padding(.top, 20)
            }
            .frame(height: 61)
            .background(Color("TabColor").edgesIgnoringSafeArea(.all))
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    func tabBarItem(_ tab: Tab, title: String, icon: String, selectedIcon: String) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 3) {
                VStack {
                    Image(systemName: (selectedTab == tab ? selectedIcon : icon))
                        .font(selectedTab == tab ? .system(size: 24).weight(.heavy) : .system(size: 24))
                        .foregroundColor(selectedTab == tab ? .primary : Color("TextColor"))
                }
                .frame(width: 55, height: 28)
                
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(selectedTab == tab ? .primary : Color("TextColor"))
            }
        }
        .frame(width: 65, height: 42)
        .onTapGesture {
            selectedTab = tab
        }
    }
    
}

//#Preview {
//    SearchView()
//}
