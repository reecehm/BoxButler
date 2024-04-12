//
//  AddLocationSheet.swift
//  BoxButler
//
//  Created by 64014784 on 4/11/24.
//

import SwiftUI
import SwiftData

struct AddItemLocationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var items: [Item]
    @Bindable var item: Item
    @State var tag: String = ""
    
    var body: some View {
            Form{
                Section{
                    TextField("Type Tag Name", text: $tag)
                }
            }
            .frame(height: 100)
            Button("Add Tag") {
                item.location.append(addTag())
            }
            .disabled(tag.isEmpty)
            .buttonStyle(.borderedProminent)
            .background(.red)
            .cornerRadius(10)
            HStack{
                VStack{
                    Text("Available Tags")
                        .multilineTextAlignment(.leading)
                        .bold()
                    ForEach(items) { item in
                        ForEach(item.location) { tag in
                            Text(tag.name)
                                .padding(.leading, 10)
                                .foregroundColor(Color.white)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(height: 27)
                                .background(Rectangle().fill(Color(.gray))
                                    .opacity(0.5))
                                    .cornerRadius(10)
                        }
                    }
                }
                Spacer()
            }
        
    }
    
    
    func addTag() -> LocationTag {
        let tag = LocationTag(name: tag)
        modelContext.insert(tag)
        return tag
    }
}

//#Preview {
//    AddItemLocationSheet()
//}
