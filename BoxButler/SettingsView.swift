//
//  SettingsView.swift
//  BoxButler
//
//  Created by 64014784 on 3/3/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {

        NavigationStack{
            ZStack {
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.gray)
                    .opacity(0.3)
                HStack {
                    Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                        Text("Toggle")
                            .font(.headline)
                        
                    }
                    .padding(.trailing, 15.0)
                    .padding(.leading, 20)
                }
                
            }
            .padding(.horizontal, 20)
        .frame(width: 400, height: 50)
        NavigationLink(destination: PreferencesView()) {
                ZStack {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.gray)
                        .opacity(0.3)
                    HStack {
                        Text("Preferences")
                            .font(.headline)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 20.0)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.black)
                            .padding(.trailing, 25.0)
                        
                    }
                    
                }
            }
            .padding(.horizontal, 20)
            .frame(width: 400, height: 50)
        }
        
    }

}

#Preview {
    SettingsView()
}
