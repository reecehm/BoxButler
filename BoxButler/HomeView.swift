//
//  Home Screen.swift
//  BoxButler
//
//  Created by 64014784 on 3/5/24.
//

import SwiftUI

struct HomeView: View {
    
    let tanColor = Color(red: 0.6784313725490196, green: 0.5098039215686274, blue: 0.4392156862745098)
    
    var body: some View {
            VStack{
                HStack{
                    Spacer()
                    Text("Not in an Organization? Click here to join a group.")
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 230
                               , height: 75
                        )
                        .background(Rectangle().fill(Color(.lightGray)))
                         .cornerRadius(10)
                    Spacer()
                    VStack{
                        Text("Username")
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: false, vertical: true)
                               .multilineTextAlignment(.center)
                               .padding()
                               .frame(width: 120
                                      , height: 40
                               )
                               .background(Rectangle().fill(Color(tanColor)))
                                .cornerRadius(10)
                        Text("Group")
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: false, vertical: true)
                               .multilineTextAlignment(.center)
                               .padding()
                               .frame(width: 120
                                      , height: 40
                               )
                               .background(Rectangle().fill(Color(tanColor)))
                                   .cornerRadius(10)
                    }
                    Spacer()
                }
                Spacer()
                HStack{
                    Button {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    } label:{
                        VStack {
                        Text("Recents")
                            .fontWeight(.bold)
                            .buttonStyle(.borderedProminent)
                            .padding()
                        Image(systemName: "clock.arrow.circlepath")
                            .resizable()
                            .frame(width:70, height: 63)
                    }
                    .frame(width: 150, height: 200)
                    }
                    .buttonStyle(.bordered)
                    Button {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    } label:{
                        VStack {
                            Text("Folders")
                                .fontWeight(.bold)
                                .buttonStyle(.borderedProminent)
                                .padding()
                            Image(systemName: "folder")
                                .resizable()
                                .frame(width:71, height: 57)
                        }
                        .frame(width: 150, height: 200)
                    }
                    .buttonStyle(.bordered)
                }
                HStack{
                    Button {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    } label:{
                        VStack {
                            Text("Scan")
                                .fontWeight(.bold)
                                .buttonStyle(.borderedProminent)
                                .padding()
                            Image(systemName: "camera")
                                .resizable()
                                .frame(width:66, height: 52)
                        }
                        .frame(width: 150, height: 200)
                    }
                    .buttonStyle(.bordered)
                    Button {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    } label:{
                        VStack {
                            Text("Changes")
                                .fontWeight(.bold)
                                .buttonStyle(.borderedProminent)
                                .padding()
                            Image(systemName: "book")
                                .resizable()
                                .frame(width:60, height: 50)
                        }
                        .frame(width: 150, height: 200)
                    }
                    .buttonStyle(.bordered)
                }
            }
            
        
        .padding(.bottom, 80.0)
    }
}
#Preview {
    HomeView()
}
