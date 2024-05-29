//
//  LocationTagSelectionView.swift
//  BoxButler
//
//  Created by 64001174 on 5/13/24.
//


import SwiftUI
import SwiftData

struct LocationTagSelectionView: View {
    @Binding var selectedTag: LocationTag
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var items: [Item]
    @Query var tags: [LocationTag]
    @State var tagText: String = ""
    @State var tagIndex: Int = 0
    @State var filteredTags: [LocationTag] = []
    
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
                        Text("Selected Tag")
                            .multilineTextAlignment(.leading)
                            .bold()
                            .padding(.leading)
                            .padding(.bottom)
                        Spacer()
                    }
                    HStack{
                        if tags.isEmpty {
                            Text("No Available Tags")
                            Image(systemName: "tag.fill")
                        }
                    }
                    
                }
                ForEach(tags) { tag in
                        HStack{
                            if tag.name == selectedTag.name {
                                Button{
                                    selectedTag = LocationTag(name: "")
                                    filterTags()
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
                .onAppear{
                    filteredTags = tags.filter { tag in
                        
                        if tag.name != selectedTag.name {
                            return true
                        }
                        return false
                    }
                }
                HStack{
                    Text("Available Tags")
                        .multilineTextAlignment(.leading)
                        .bold()
                        .padding(.leading)
                        .padding(.bottom)
                        .padding(.top)
                    Spacer()
                }
                ForEach(filteredTags) { tag in
                        HStack{
                                Button{
                                    selectedTag = tag
                                    filterTags()
                                } label: {
                                    Text(tag.name)
                                        .foregroundColor(Color.white)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .frame(height: 27)
                                        .background(Rectangle().fill(Color(.gray))
                                            .opacity(0.8))
                                        .cornerRadius(10)
                                        .padding(.leading)
                                    Spacer()
                                }

                        }
                    }
            }
        Spacer()
    }
    
    func filterTags() {
        filteredTags = tags.filter { tag in
            
            if tag.name != selectedTag.name {
                return true
            }
            return false
        }
    }
}
