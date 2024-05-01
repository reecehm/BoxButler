//
//  ContentView.swift
//  BarcodeTextScanner
//
//  Created by Alfian Losari on 6/25/22.
//

import SwiftUI
import VisionKit


struct ScannerView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var scanState: ScanState
    @EnvironmentObject var vm: AppViewModel
    
    @Binding var selectedTab: Tab
    
    @State private var capturedBarcode: String?
    @State private var didCapture: Bool = false
    @State private var showPopup = false
  

    
    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = [
        ("All", .none),
        ("URL", .URL),
        ("Phone", .telephoneNumber),
        ("Email", .emailAddress),
        ("Address", .fullStreetAddress)
    ]
    
    var body: some View {
        ZStack{
            switch vm.dataScannerAccessStatus {
            case .scannerAvailable:
                mainView
            case .cameraNotAvailable:
                Text("Your device doesn't have a camera")
            case .scannerNotAvailable:
                Text("Your device doesn't have support for scanning barcode with this app")
            case .cameraAccessNotGranted:
                Text("Please provide access to the camera in settings")
            case .notDetermined:
                Text("Requesting camera access")
            }
            if showPopup {
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                        .background(Rectangle().fill(.thinMaterial))
                    Text("Item added")
                        .foregroundColor(.green)
                        .padding()
                        .background(Rectangle().fill(.thinMaterial))
                }
                .background(Color.white)
                .cornerRadius(16)
            }
        }
    }
    
    private var mainView: some View {
        DataScannerView(
            recognizedItems: $vm.recognizedItems,
            recognizedDataType: vm.recognizedDataType,
            recognizesMultipleItems: vm.recognizesMultipleItems)
            .background { Color.gray.opacity(0.3) }
            .ignoresSafeArea()
            .id(vm.dataScannerViewId)
            .sheet(isPresented: .constant(true)) {
                bottomContainerView
                    .background(.ultraThinMaterial)
                    .presentationDetents([.height(275)])
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled()
                    .onAppear {
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
                            return
                        }
                        controller.view.backgroundColor = .clear
                    }
            }
            .onChange(of: vm.scanType) {  vm.recognizedItems = [] }
            .onChange(of: vm.textContentType) {  vm.recognizedItems = [] }
            .onChange(of: vm.recognizesMultipleItems) {  vm.recognizedItems = []}
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                Picker("Scan Type", selection: $vm.scanType) {
                    Text("Barcode").tag(ScanType.barcode)
                    Text("Text").tag(ScanType.text)
                }.pickerStyle(.segmented)
                
                Toggle("Scan multiple", isOn: $vm.recognizesMultipleItems)
            }.padding(.top)
            
            if vm.scanType == .text {
                Picker("Text content type", selection: $vm.textContentType) {
                    ForEach(textContentTypes, id: \.self.textContentType) { option in
                        Text(option.title).tag(option.textContentType)
                    }
                }.pickerStyle(.segmented)
            }
            
            Text(vm.headerText).padding(.top)
        }.padding(.horizontal)
    }

    private var bottomContainerView: some View {
        VStack {
            headerView
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(vm.recognizedItems) { item in
                        switch item {
                        case .barcode(let barcode):
                            Text(barcode.payloadStringValue ?? "Unknown barcode")
                        case .text(let text):
                            Text(text.transcript)
                        @unknown default:
                            Text("Unknown")
                        }
                    }
                }
                .padding()
            }
            .onReceive(vm.$recognizedItems) { recognizedItems in
                // Check if a barcode is recognized
                if let barcode = recognizedItems.compactMap({ item -> String? in
                    if case let .barcode(barcode) = item {
                        return barcode.payloadStringValue
                    }
                    return nil
                }).first {
                    // Update the capturedBarcode variable
                    capturedBarcode = barcode
                    didCapture = true
                } else {
                    // No barcode recognized, reset variables
                    capturedBarcode = nil
                    didCapture = false
                }
            }
            if didCapture {
                if let barcodeValue = capturedBarcode {
                    // Display the "Add Item" button if a barcode is recognized
                    Button(action: {
                        // Call the API to add the item
                        addItemForBarcode(barcodeValue)
                        // Reset capturedBarcode and didCapture after adding item
                        capturedBarcode = nil
                        didCapture = false
                        // Show the popup
                        showPopup = true
                        // Hide the popup after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showPopup = false
                        }
                    }) {
                        Text("Add Item for \(barcodeValue)")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
            tabBarView
        }
    }



    // Function to add item for the recognized barcode
    func addItemForBarcode(_ barcode: String) {
        // Define the URL
        let urlString = "https://api.upcdatabase.org/product/\(barcode)"// Note: query parameters should be properly encoded
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            // Handle error
            return
        }
        
        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Set the Authorization header
        let apiKey = "1539DB77B48B9E15315867D60D061CA7"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // Create the URLSession
        let session = URLSession.shared
        
        // Create the data task
        let task = session.dataTask(with: request) { data, response, error in
            // Check for errors
                if let error = error {
                    print("Error: \(error)")
                    // Handle error
                    return
                }

                // Check if there is data
                guard let data = data else {
                    print("No data received")
                    // Handle empty response
                    return
                }

                // Parse the API response into Item instances
                if let items = parseItems(from: data) {
                    // Handle parsed items here
                    // Update your view model or UI with the received items
                    for item in items {
                        modelContext.insert(item)
                    }
                } else {
                    print("Failed to parse API response into items")
                    // Handle parsing failure
                }
        }
        
        // Resume the task
        task.resume()
    }

    var tabBarView: some View {
        ZStack{
            VStack(spacing: 0) {
                Divider()
                
                HStack(spacing: 9) {
                    tabBarItem(.first, title: "Home", icon: "house", selectedIcon: "house.fill")
                    tabBarItem(.second, title: "Shelf", icon: "shippingbox", selectedIcon: "shippingbox.fill")
                    tabBarItem(.third, title: "Search", icon: "magnifyingglass", selectedIcon: "magnifyingglass")
                    tabBarItem(.fourth, title: "Scan", icon: "barcode.viewfinder", selectedIcon: "barcode.viewfinder")
                    tabBarItem(.fifth, title: "Settings", icon: "gear", selectedIcon: "gear")
                }
                .padding(.top, 20)
            }
            .frame(height: 50)
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
    
    func parseItems(from data: Data) -> [Item]? {
        do {
            let jsonDecoder = JSONDecoder()
            let response = try jsonDecoder.decode(APIResponse.self, from: data)
            return [Item(itemName: response.title,
                         quantity: "",
                         itemDetails: response.description,
                         location: [],
                         quantityWarn: "")]
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }

    // Define structures to match the API response
    struct APIResponse: Decodable {
        let success: String
        let barcode: String
        let title: String
        let alias: String
        let description: String
        let brand: String
        let manufacturer: String
        let mpn: String
        let msrp: String
        let ASIN: String
        let category: String
        let images: [String]
    }

}




