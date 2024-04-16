//
//  EditPersonView.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//
import PhotosUI
import SwiftData
import SwiftUI

struct EditItemView: View {
    @Bindable var item: Item
    @Query var boxes: [Box]
    @State private var selectedItem: PhotosPickerItem?
    @Binding var isShowingAddLocationSheet: Bool

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
            }
            
            Section {
                TextField("Item Name", text: $item.itemName)
                TextField("Quantity", text: $item.quantity)
                TextField("Price", value: $item.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            }
            Section{
                HStack{
                    Button{
                        isShowingAddLocationSheet = true
                    } label: {
                        Text("Edit Location Tags")
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
                            .background(Rectangle().fill(Color(.red))
                                .opacity(0.8))
                            .cornerRadius(10)
                        Spacer()
                    }
                }
            }
            
            Section("Notes"){
                TextField("Details about this Item", text: $item.itemDetails, axis: .vertical)
            }
        }
            .onChange(of: selectedItem, loadPhoto)
        }
    
    
    
    
    func loadPhoto () {
        Task { @MainActor in
            item.photo = try await
            selectedItem?.loadTransferable(type: Data.self)
        }
    }
    
}



//#Preview {
//    EditPersonView()
//}
