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
    
    var body: some View {
        NavigationStack{
            ItemsListView(searchString: searchText)
                .navigationTitle("Search")
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    SearchView()
}
