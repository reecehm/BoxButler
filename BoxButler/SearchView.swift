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
    @Query var tags: [LocationTag]
    @State var isSaved = true
    @State var activeTagArray: [LocationTag] = []
    @State var availableTagArray: [LocationTag] = []
    @State var search = true
    @State var hasSearched = false
    
    var body: some View {
        NavigationStack{
            VStack {
                ItemsListView(searchString: searchText, selectedTab: $selectedTab, search: $search, hasSearched: $hasSearched)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .navigationDestination(for: Item.self) { item in
                        EditItemView(item: item, isShowingAddLocationSheet: $isShowingAddLocationSheet, shouldShowPlus: $shouldShowPlus)
                            .sheet(isPresented: $isShowingAddLocationSheet, content: {
                                AddItemLocationSheet(item: item, isSaved: $isSaved, activeTagArray: $activeTagArray, availableTagArray: $availableTagArray)
                            })
                    }
                    .navigationDestination(for: Box.self) { box in
                        EditBoxView(box: box, isShowingAddLocationSheet: $isShowingAddLocationSheet, shouldShowPlus: $shouldShowPlus)
                            .sheet(isPresented: $isShowingAddLocationSheet, content: {
                                AddBoxLocationSheet(box: box, isSaved: $isSaved, activeTagArray: $activeTagArray, availableTagArray: $availableTagArray)
                            })
                    }
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Search")
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
    
}

//#Preview {
//    SearchView()
//}
