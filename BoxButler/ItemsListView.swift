//
//  ListsView.swift
//  BoxButler
//
//  Created by 64014784 on 3/7/24.
//
import SwiftData
import SwiftUI

extension String {
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
}

struct ItemsListView: View {
    @Environment(\.modelContext) var modelContext
    @State private var searchText = ""
    @Query var items: [Item]
    @Query var boxes: [Box]
    @Query var changes: [Change]
    @Query var tags: [LocationTag]
    @Environment(\.isSearching) var isSearching
    @Binding var search: Bool
    @Binding var selectedTab: Tab
    @State private var isShowingLocationTagSheet = false
    @State var selectedTag = LocationTag(name: "")
    @State var filteredItems: [Item] = []
    @Binding var hasSearched: Bool
    @State private var animate = false
    
    var body: some View {
            if !isSearching && search {
                HStack{
                    Button(action: {
                        isShowingLocationTagSheet.toggle()
                    }) {
                        Text("Sort by Location Tag")
                    }
                    .buttonStyle(.bordered)
                    .sheet(isPresented: $isShowingLocationTagSheet, content: {
                        LocationTagSelectionView(selectedTag: $selectedTag)
                            .presentationDetents([.large])
                            .presentationBackground(.ultraThinMaterial)
                    })
                    .padding(.bottom)
                    .padding(.leading)
                    if selectedTag.name != "" {
                        Button{
                            selectedTag = LocationTag(name: "")
                        } label: {
                            HStack{
                                Text(selectedTag.name)
                                Image(systemName: "xmark.app.fill")
                            }
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(height: 27)
                            .background(Rectangle().fill(Color("AccentColor")))
                            .cornerRadius(10)
                            .padding(.leading)
                            .padding(.bottom)
                        }
                    }
                    
                    Spacer()
                }
            }
            List {
                if hasSearched {
                    HStack{
                        Text("")
                            .opacity(0.0)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                ForEach(items) { item in
                    if filteredItems.contains(item){
                        VStack{
                            NavigationLink(value: item){
                                HStack{
                                    Image(systemName: "pencil")
                                    Text(item.itemName)
                                        .font(.system(size: 20, weight: .bold))
                                    Spacer()
                                    if let imageData = item.photo, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(5)
                                            .overlay(
                                                Rectangle().stroke(Color.primary, lineWidth: 3)
                                                    .cornerRadius(5)
                                            )
                                            .shadow(radius: 3)
                                    }
                                }
                            }
                            ForEach(item.location) { tag in
                                HStack{
                                    Text(tag.name)
                                        .foregroundColor(Color.white)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .frame(height: 27)
                                        .background(Rectangle().fill(Color("AccentColor")))
                                        .cornerRadius(10)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
                ForEach(boxes) { box in
                    VStack{
                        NavigationLink(value: box){
                            HStack{
                                Image(systemName: "shippingbox.fill")
                                Text(box.boxName)
                                    .font(.system(size: 20, weight: .bold))
                                Spacer()
                                if let imageData = box.photo, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                        .overlay(
                                            Rectangle().stroke(Color.primary, lineWidth: 3)
                                                .cornerRadius(5)
                                        )
                                        .shadow(radius: 3)
                                }
                            }
                            
                        }
                        ForEach(box.location) { tag in
                            HStack{
                                Text(tag.name)
                                    .foregroundColor(Color.white)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .frame(height: 27)
                                    .background(Rectangle().fill(Color("AccentColor")))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBoxes)
            }
            .overlay {
                if items.isEmpty && boxes.isEmpty && search {
                    ContentUnavailableView(label: {
                        Label("No Items", systemImage: "circle.grid.3x3.fill")
                    })
                }
            }
            .onChange(of: isSearching, spacerFunction)
            .padding(.bottom, -10)
            .padding(.top, 10)
            .onChange(of: selectedTag, filterItems)
            .onChange(of: items, filterItems)
            .onAppear{
                filterItems()
            }
            
            if !isSearching && search {
                tabBarView
            }
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
                        tabBarItem(.fourth, title: "Settings", icon: "gear", selectedIcon: "gear")
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
    
    
    init(searchString: String = "", selectedTab: Binding<Tab>, search: Binding<Bool>, hasSearched: Binding<Bool>) {
      _items = Query(filter: #Predicate { item in
        // Check for empty search string or match in name
          (searchString.isEmpty || item.itemName.localizedStandardContains(searchString))
      })

      _boxes = Query(filter: #Predicate { box in
        searchString.isEmpty || box.boxName.localizedStandardContains(searchString)
      })

      self._selectedTab = selectedTab
      self._search = search
      self._hasSearched = hasSearched
    }

    func filterItems() {
        filteredItems = items.filter { item in
            for tag in item.location  {
                if selectedTag.name == "" || selectedTag.name == tag.name {
                    return true
                }
            }
            if selectedTag.name == "" && item.location.isEmpty {
                return true
            }
            return false
        }
    }
    
    func spacerFunction() {
        if hasSearched == false {
            hasSearched = true
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for offsets in offsets {
            let item = items[offsets]
            let change = Change(changeType: "Item deleted", originalVar: "nonexistant item", newVar: item.itemName, nameOfChangedItem: item.itemName, date: dateFormatter(date: Date()))
            modelContext.insert(change)
            modelContext.delete(item)
        }
    }
    func deleteBoxes(at offsets: IndexSet) {
        for offsets in offsets {
            let box = boxes[offsets]
            let change = Change(changeType: "Box deleted", originalVar: "nonexistant item", newVar: box.boxName, nameOfChangedItem: box.boxName, date: dateFormatter(date: Date()))
            modelContext.insert(change)
            modelContext.delete(box)
        }
    }
}

func dateFormatter(date: Date) -> String{
    let date = date
    
    let formatter = DateFormatter()
    formatter.dateFormat = "M/d/yy h:mm a"
    formatter.timeZone = TimeZone(abbreviation: "CST")!  // Set to CST time zone

    let formattedDate = formatter.string(from: date)
    return(formattedDate)
}

struct itemStruct {
    static var originalItem: Item = Item(itemName: "", quantity: "", itemDetails: "", location: [], quantityWarn: "")
    static var locationTagName: [String] = []
}

struct boxStruct {
    static var originalBox: Box = Box(boxName: "", boxQuantity: "", boxDetails: "", location: [])
    static var locationTagName: [String] = []
}


//#Preview {
//    ItemsListView()
//}
