//  EditPersonView.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//
import PhotosUI
import SwiftData
import SwiftUI

struct EditItemView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var item: Item
    @Query var boxes: [Box]
    
    @State private var selectedItem: PhotosPickerItem?
    @Binding var isShowingAddLocationSheet: Bool
    @Binding var shouldShowPlus: Bool
    @Query var changes: [Change]
    @State private var capturedImage: UIImage?
    @State private var isShowingPhotoCaptureView = false
    
    
    var body: some View {
        
        Form {
            Section{
                if let imageData = item.photo, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo",systemImage: "camera.on.rectangle")
                }
                Button(action: {
                    isShowingPhotoCaptureView = true
                }) {
                    Label("Take a Photo", systemImage: "camera")
                }
                
            }
            
            Section("Item Name") {
                TextField("Item Name", text: $item.itemName)
            }
            Section("Quantity") {
                TextField("Quantity", text: $item.quantity)
                    .keyboardType(.numberPad)
            }
            Section("Price"){
                TextField("Price", value: $item.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            Section("Quantity Warning Threshold"){
                
                TextField("Min Level", text:$item.quantityWarn)
                    .keyboardType(.numberPad)
            }
            Section{
                HStack{
                    Button{
                        isShowingAddLocationSheet = true
                    } label: {
                        Text("Edit Tags")
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
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
            
            Section("Notes"){
                TextField("Details about this Item", text: $item.itemDetails, axis: .vertical)
            }
        }
        .sheet(isPresented: $isShowingPhotoCaptureView, onDismiss: loadImage) {
            PhotoCaptureView(isPresented: $isShowingPhotoCaptureView, capturedImage: $capturedImage)
        }
        .navigationTitle("Edit Item")
        .onChange(of: selectedItem, loadPhoto)
        .onAppear{
            shouldShowPlus = true
            itemStruct.originalItem.itemName = item.itemName
            itemStruct.originalItem.quantity = item.quantity
            itemStruct.originalItem.price = item.price
            itemStruct.originalItem.itemDetails = item.itemDetails
            if !item.location.isEmpty{
                for tag in item.location {
                    itemStruct.locationTagName = []
                    itemStruct.locationTagName.append(tag.name)
                    print("appended one tag")
                }
            }
            else{
                itemStruct.locationTagName = []
            }
            itemStruct.originalItem.quantityWarn = item.quantityWarn
        }
        .onDisappear{
            if item.itemName != itemStruct.originalItem.itemName && !itemStruct.originalItem.itemName.isEmpty {
                let change = Change(changeType: "Item Name", originalVar: itemStruct.originalItem.itemName, newVar: item.itemName, nameOfChangedItem: itemStruct.originalItem.itemName, date: dateFormatter(date: Date()))
                modelContext.insert(change)
            }
            if item.quantity != itemStruct.originalItem.quantity && !itemStruct.originalItem.quantity.isEmpty{
                let change = Change(changeType: "Quantity", originalVar: itemStruct.originalItem.quantity, newVar: item.quantity, nameOfChangedItem: itemStruct.originalItem.itemName, date: dateFormatter(date: Date()))
                modelContext.insert(change)
            }
            if item.price != itemStruct.originalItem.price {
                let originalPriceString = String(describing: itemStruct.originalItem.price)
                let newPriceString = String(describing: item.price)
                let change = Change(changeType: "Price", originalVar: originalPriceString, newVar: newPriceString, nameOfChangedItem: item.itemName, date: dateFormatter(date: Date()))
                modelContext.insert(change)
            }
            if item.itemDetails != itemStruct.originalItem.itemDetails && !itemStruct.originalItem.itemDetails.isEmpty {
                let change = Change(changeType: "Item Details", originalVar: itemStruct.originalItem.itemDetails, newVar: item.itemDetails, nameOfChangedItem: item.itemName, date: dateFormatter(date: Date()))
                modelContext.insert(change)
            }
            if item.location.count < itemStruct.locationTagName.count {
                var locationNames: [String] = []
                if !item.location.isEmpty{
                    for location in item.location {
                        print("location name appended")
                        locationNames.append(location.name)
                    }
                    for name in itemStruct.locationTagName {
                        if !locationNames.contains(name) {
                            let change = Change(changeType: "Removed Tag", originalVar: name, newVar: "", nameOfChangedItem: item.itemName, date: dateFormatter(date: Date()))
                            modelContext.insert(change)
                        }
                    }
                }
                else{
                    for name in itemStruct.locationTagName {
                        print("added one change")
                        let change = Change(changeType: "Removed Tag", originalVar: name, newVar: "", nameOfChangedItem: item.itemName, date: dateFormatter(date: Date()))
                        modelContext.insert(change)
                    }
                }
            }
            if item.location.count > itemStruct.locationTagName.count {
                for location in item.location {
                    if !itemStruct.locationTagName.contains(location.name) {
                        let change = Change(changeType: "Added Tag", originalVar: "", newVar: location.name, nameOfChangedItem: item.itemName, date: dateFormatter(date: Date()))
                        modelContext.insert(change)
                    }
                }
            }
            if item.quantityWarn != itemStruct.originalItem.quantityWarn && !itemStruct.originalItem.quantityWarn.isEmpty{
                let change = Change(changeType: "Quantity Warn", originalVar: itemStruct.originalItem.quantityWarn, newVar: item.quantityWarn, nameOfChangedItem: itemStruct.originalItem.itemName, date: dateFormatter(date: Date()))
                modelContext.insert(change)
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
    
    
    func loadPhoto () {
        Task { @MainActor in
            item.photo = try await
            selectedItem?.loadTransferable(type: Data.self)
            let change = Change(changeType: "Photo", originalVar: itemStruct.originalItem.itemName, newVar: item.itemName, nameOfChangedItem: item.itemName, date: dateFormatter(date: Date()))
            modelContext.insert(change)
        }
    }
    func loadImage() {
        guard let capturedImage = capturedImage else { return }
        // Here you can save the captured image to your item or perform any other actions
        // For now, I'm just assigning it directly to the item's photo
        item.photo = capturedImage.pngData()
        let change = Change(changeType: "Photo", originalVar: itemStruct.originalItem.itemName, newVar: item.itemName, nameOfChangedItem: item.itemName, date: dateFormatter(date: Date()))
        modelContext.insert(change)

    }
    
}

struct PhotoCaptureView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var capturedImage: UIImage?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: PhotoCaptureView
        
        init(parent: PhotoCaptureView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImage = image
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}




//#Preview {
//    EditPersonView()
//}
