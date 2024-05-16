//
//  SettingsView.swift
//  BoxButler
//
//  Created by 64014784 on 3/3/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}

struct SettingsView: View {
    
    @State private var showSignInView = false
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {

        NavigationView{
            Form {
                Section (header: Text("Profile")) {
                    if showSignInView{
                        NavigationLink(destination: NewUserView(showSignInView: $showSignInView)){
                            Text("Create A Profile")
                        }
                        NavigationLink(destination: LoginView(showSignInView: $showSignInView)){
                            Text("Sign In")
                        }
                    }
                    else {
                        Button("Log Out") {
                            do {
                                try viewModel.logOut()
                                showSignInView = true
                            } catch {
                                 print(error)
                            }
                        }
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
        .onAppear{
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
    }
}

#Preview {
    SettingsView()
}
