//
//  EditPersonView.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//
import SwiftData
import SwiftUI

struct EditPersonView: View {
    @Bindable var person: Person
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $person.name)
                    .textContentType(.name)
                
                TextField("Email Address", text: $person.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
            }
            Section {
                TextField("Detail about this person", text: $person.details, axis: .vertical)
            }

        }
        .navigationTitle("Edit Person")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    EditPersonView()
//}
