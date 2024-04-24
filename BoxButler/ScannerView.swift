//
//  ContentView.swift
//  BarcodeTextScanner
//
//  Created by Alfian Losari on 6/25/22.
//

import SwiftUI
import VisionKit


struct ScannerView: View {
    @EnvironmentObject var scanState: ScanState
    @EnvironmentObject var vm: AppViewModel
    
    @Binding var selectedTab: Tab
    
    @State private var capturedBarcode: String?
    @State private var didCapture: Bool = false
  

    
    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = [
        ("All", .none),
        ("URL", .URL),
        ("Phone", .telephoneNumber),
        ("Email", .emailAddress),
        ("Address", .fullStreetAddress)
    ]
    
    var body: some View {
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
                                .onReceive(vm.$recognizedItems) { recognizedItems in
                                // Check if a barcode is recognized
                                    if case let .barcode(barcode) = recognizedItems.first {
                                        // Update the capturedBarcode variable
                                        capturedBarcode = barcode.payloadStringValue
                                        didCapture = true
                                    }
                                    
                                }
                            
                        case .text(let text):
                            Text(text.transcript)
                            
                        @unknown default:
                            Text("Unknown")
                        }
                    }
            
                    if didCapture {
                        if let barcodeValue = capturedBarcode {
                            // Display the "add item" button if a barcode is recognized
                            
                            
                            Button(action: {
                                
                            }) {
                                Text("Add Item for \(barcodeValue)")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
            }
            tabBarView
        }
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
}

