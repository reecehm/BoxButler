//
//  EditPersonView.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//
import SwiftData
import SwiftUI

struct EditItemView: View {
    @Bindable var item: Item
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $item.name)
                    .textContentType(.name)
                
                TextField("Email Address", text: $item.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
            }
            Section {
                TextField("Detail about this item", text: $item.details, axis: .vertical)
            }

        }
        .navigationTitle("Edit Item")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    EditPersonView()
//}
