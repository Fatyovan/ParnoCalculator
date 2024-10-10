//
//  SignInView.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import SwiftUI

struct SignInView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isSignedUp = false
    @State private var loginError: String?
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: login) {
                    Text("Login")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
            }
            .navigationBarTitle("Login")
        }
        .background(
            NavigationLink("", destination: MainCalculationView(), isActive: $isSignedUp)
        )
    }
    
    func login() {
        let success = userViewModel.logIn(username: username, password: password)
        
        if !success {
            loginError = "Invalid username or password. Please try again."
        } else {
            loginError = nil
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
