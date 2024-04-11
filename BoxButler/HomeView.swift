//
//  Home Screen.swift
//  BoxButler
//
//  Created by 64014784 on 3/5/24.
//
import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query var items: [Item]

    let tanColor = Color(red: 0.6784313725490196, green: 0.5098039215686274, blue: 0.4392156862745098)
    
    let greyColor = Color(red: 0.9137, green: 0.9137, blue: 0.9215)
    
    var body: some View {
            VStack{
                ZStack {
                    HStack{
                        Spacer()
                        Text("Not in an Organization? Click here to join a group.")
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(width: 230
                                   , height: 88
                            )
                            .background(Rectangle().fill(.thinMaterial))
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
                }
                HStack {
                    VStack {
                        Text("Number of Items")
                        Text(String(items.count))
                    }
                }
                
                Spacer()
            }
            
        
        .padding(.bottom, 80.0)
    }
}
#Preview {
    HomeView()
}
