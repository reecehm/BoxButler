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
        ZStack{
            VStack{
                HStack{
                    Text("Not in an Organization? Click here to join a group.")
                    Spacer()
                    VStack{
                        Text("Username")
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: false, vertical: true)
                               .multilineTextAlignment(.center)
                               .padding()
                               .frame(width: 150
                                      , height: 40
                               )
                               .background(Rectangle().fill(Color(tanColor)))
                                .cornerRadius(30)
                        Text("Group")
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: false, vertical: true)
                               .multilineTextAlignment(.center)
                               .padding()
                               .frame(width: 150
                                      , height: 40
                               )
                               .background(Rectangle().fill(Color(tanColor)))
                                   .cornerRadius(30)
                        Text("Settings")
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: false, vertical: true)
                               .multilineTextAlignment(.center)
                               .padding()
                               .frame(width: 150
                                      , height: 40
                               )
                               .background(Rectangle().fill(Color(tanColor)))
                                   .cornerRadius(30)
                    }
                }
                .padding()
                HStack{
                    Button {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    } label:{
                        Text("Recents")
                            .fontWeight(.bold)
                            .buttonStyle(.borderedProminent)
                            .frame(width: 150, height: 200)
                    }
                    .buttonStyle(.bordered)
                    Button {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    } label:{
                        Text("Folders")
                            .fontWeight(.bold)
                            .buttonStyle(.borderedProminent)
                            .frame(width: 150, height: 200)
                    }
                    .buttonStyle(.bordered)
                }
                HStack{
                    Button {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    } label:{
                        Text("Scan")
                            .fontWeight(.bold)
                            .buttonStyle(.borderedProminent)
                            .frame(width: 150, height: 200)
                    }
                    .buttonStyle(.bordered)
                    Button {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    } label:{
                        Text("Changes")
                            .fontWeight(.bold)
                            .buttonStyle(.borderedProminent)
                            .frame(width: 150, height: 200)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}
#Preview {
    HomeView()
}
