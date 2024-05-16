//
//  LocationTagSelectionView.swift
//  BoxButler
//
//  Created by 64001174 on 5/13/24.
//


import SwiftUI
import SwiftData

struct LocationTagSelectionView: View {
    @Binding var selectedLocationTag: String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var items: [Item]
    @Query var tags: [LocationTag]
    @State var tagText: String = ""
    @State var tagIndex: Int = 0
    
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
                        Text("Selected Tags")
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
                            if tag.name == selectedLocationTag {
                                Button{
                                    selectedLocationTag = ""
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
                HStack{
                    Text("Available Tags")
                        .multilineTextAlignment(.leading)
                        .bold()
                        .padding(.leading)
                        .padding(.bottom)
                        .padding(.top)
                    Spacer()
                }
                ForEach(tags) { tag in
                        HStack{
                            if tag.name != selectedLocationTag {
                                Button{
                                    selectedLocationTag = tag.name
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
            }
        Spacer()
    }
}

