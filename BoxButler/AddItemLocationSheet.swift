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
    @Query var tags: [LocationTag]
    @Bindable var item: Item
    @State var tag: String = ""
    
    var body: some View {
            VStack{
                Button ("Done") {
                    dismiss()
                }
                .padding(.top, 10)
                .padding(.bottom, 5)
                
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
            .cornerRadius(10)
            Divider()
            HStack{
                VStack{
                    HStack{
                        Text("Available Tags")
                            .multilineTextAlignment(.leading)
                            .bold()
                            .padding(.leading)
                        Spacer()
                    }
                        ForEach(items) { item in
                            ForEach(item.location) { tag in
                                HStack{
                                    Text(tag.name)
                                        .foregroundColor(Color.white)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .frame(height: 27)
                                        .background(Rectangle().fill(Color(.gray))
                                            .opacity(0.5))
                                        .cornerRadius(10)
                                        .padding(.leading)
                                    Spacer()
                                }
                            }
                        }
                    .overlay{
                        if tags.isEmpty {
                            ContentUnavailableView(label: {
                                Label("No Tags", systemImage: "tag.fill")
                            })
                        }
                    }
                }
                Spacer()
            }
                Divider()
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
