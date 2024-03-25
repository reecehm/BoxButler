//
//  PreferencesView.swift
//  BoxButler
//
//  Created by 64001174 on 3/14/24.
//

import SwiftUI

struct PreferencesView: View {
    var body: some View {

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

    }
}

#Preview {
    PreferencesView()
}
