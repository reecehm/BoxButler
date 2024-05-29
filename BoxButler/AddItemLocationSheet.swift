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
    @Binding var isSaved: Bool
    @State var tagText: String = ""
    @State var tagIndex: Int = 0
    @Binding var activeTagArray: [LocationTag]
    @Binding var availableTagArray: [LocationTag]
    
    
    var body: some View {
            VStack{
                HStack{
                    Button ("Done") {
                        dismiss()
                    }
                    .padding(.top, 15)
                    .padding(.bottom, 5)
                    .padding(.leading, 15)
                    Spacer()
                }
                VStack{
                    HStack{
                        Text("Active Tags")
                            .multilineTextAlignment(.leading)
                            .bold()
                            .padding(.leading)
                            .padding(.bottom)
                        Spacer()
                    }
                    HStack{
                        if item.location.isEmpty && activeTagArray.isEmpty {
                            Text("No Active Tags")
                            Image(systemName: "tag.fill")
                        }
                    }
                }
                if isSaved {
                    ForEach(item.location) { tag in
                            HStack{
                                Button{
                                    tagIndex = item.location.firstIndex(of: tag)!
                                    item.location.remove(at: tagIndex)
                                } label: {
                                    Text(tag.name)
                                        .foregroundColor(Color.white)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .frame(height: 27)
                                        .background(Rectangle().fill(Color("AccentColor")))
                                        .cornerRadius(10)
                                        .padding(.leading)
                                    Spacer()
                                }
                            }
                        }
                }
                else {
                    ForEach(activeTagArray) { tag in
                            HStack{
                                Button{
                                    tagIndex = activeTagArray.firstIndex(of: tag)!
                                    activeTagArray.remove(at: tagIndex)
                                } label: {
                                    Text(tag.name)
                                        .foregroundColor(Color.white)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .frame(height: 27)
                                        .background(Rectangle().fill(Color("AccentColor")))
                                        .cornerRadius(10)
                                        .padding(.leading)
                                    Spacer()
                                }
                            }
                        }
                }
            TextField("Add A New Tag", text: $tagText)
                    .textFieldStyle(.roundedBorder)
                    .bold()
                    .padding()
            .frame(height: 100)
            Button("Add Tag") {
                if isSaved {
                    item.location.append(addTag())
                }
                else{
                    availableTagArray.append(addTag())
                }
                tagText = ""
            }
            .disabled(tagText.isEmpty)
            .buttonStyle(.borderedProminent)
            .cornerRadius(10)
            Divider()
            HStack{
                VStack{
                    VStack{
                        HStack{
                            Text("Available Tags")
                                .multilineTextAlignment(.leading)
                                .bold()
                                .padding(.leading)
                                .padding(.bottom)
                            Spacer()
                        }
                        HStack{
                            if tags.isEmpty && availableTagArray.isEmpty {
                                Text("No Tags")
                                Image(systemName: "tag.fill")
                            }
                        }
                    }
                    if isSaved {
                        ForEach(tags) { tag in
                            if !item.location.contains(tag){
                                HStack{
                                    Button{
                                        item.location.append(tag)
                                    } label: {
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
                        }
                    }
                    else {
                        ForEach(availableTagArray) { tag in
                            if !activeTagArray.contains(tag){
                                HStack{
                                    Button{
                                        activeTagArray.append(tag)
                                    } label: {
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
                        }
                    }
                }
                Spacer()
            }
                Divider()
                Spacer()
            }
            .onAppear{
                if availableTagArray.isEmpty{
                    for tag in tags {
                        availableTagArray.append(tag)
                    }
                }
            }
    }
    
    
    
    func addTag() -> LocationTag {
        let tag = LocationTag(name: tagText)
        activeTagArray.append(tag)
        return tag
    }
}

//#Preview {
//    AddItemLocationSheet()
//}
