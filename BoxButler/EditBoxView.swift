//
//  EditBoxView.swift
//  BoxButler
//
//  Created by 64014784 on 4/10/24.
//
import SwiftData
import SwiftUI
import PhotosUI

struct EditBoxView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var box: Box
    @Query var items: [Item]
    @State private var selectedItem: PhotosPickerItem?
    @Binding var isShowingAddLocationSheet: Bool
    @Binding var shouldShowPlus: Bool

    
    var body: some View {
        Form {
            Section{
                if let imageData = box.photo, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo",systemImage: "camera.on.rectangle")
                }
            }
            Section ("Box Name") {
                TextField("Box Name", text: $box.boxName)
                TextField("Units Per Box", text: $box.boxQuantity)
                TextField("Price", value: $box.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
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
                ForEach(box.location) { tag in
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
        }
        .navigationTitle("Edit Box")
        .onChange(of: selectedItem, loadPhoto)
        .onAppear{
            shouldShowPlus = true
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for offsets in offsets {
            let item = items[offsets]
            modelContext.delete(item)
        }
    }
    
    func loadPhoto () {
        Task { @MainActor in
            box.photo = try await
            selectedItem?.loadTransferable(type: Data.self)
        }
    }
}

//#Preview {
//    EditBoxView()
//}



