//
//  LoginView.swift
//  BoxButler
//
//  Created by 64014784 on 5/10/24.
//
import SwiftUI
import Firebase

final class LogInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func logIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
}

struct LoginView: View {
  @State private var logInError: String?
  @Binding var showSignInView: Bool
  @StateObject private var viewModel = LogInEmailViewModel()


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

        Button("Log In") {
            Task{
                do {
                    try await viewModel.logIn()
                    showSignInView = false
                    return
                } catch {
                    logInError = ("Error occurred")
                  }
                }
            }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(5)
          if let error = logInError {
            Text(error)
              .foregroundColor(.red)
          }
        }
        

        
//        NavigationLink(value: true, destination: Text("Logged In")) {
//          EmptyView()
//        }
//        .isPresented($isLoggedIn)
      }
      .padding()
    }
  }



//#Preview {
//    LoginView()
//}
