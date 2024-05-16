//
//  NewUserView.swift
//  BoxButler
//
//  Created by 64014784 on 5/10/24.
//

import SwiftUI
import Firebase

final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
}

struct NewUserView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
  @State private var error: String?
    @Binding var showSignInView: Bool

  var body: some View {
    NavigationView {
      VStack {
          TextField("Email", text: $viewModel.email)
          .disableAutocorrection(true)
          .autocapitalization(.none)
          .padding()
          .background(Color(.systemGray6))

          SecureField("Password", text: $viewModel.password)
          .disableAutocorrection(true)
          .autocapitalization(.none)
          .padding()
          .background(Color(.systemGray6))

        Button("Create User") {
            Task{
                do {
                    try await viewModel.signIn()
                    showSignInView = false
                }catch{
                    print(error)
                }
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(5)

        if let error = error {
          Text(error)
            .foregroundColor(.red)
        }
      }
      .padding()
    }
  }
}


//#Preview {
//    NewUserView()
//}
