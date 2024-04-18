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
                Form {
                    Section("Preferences"){
                        HStack{
                            Button{
                                
                            } label: {
                                Text("Dark Mode")
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }

                        
                    }
                    
                    
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
