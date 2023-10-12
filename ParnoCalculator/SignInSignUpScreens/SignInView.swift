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
    @State private var loginError = false
    @State private var isSignedUp = false
    
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
                
                if loginError {
                    Text("Invalid username or password").foregroundColor(.red)
                }
            }
            .navigationBarTitle("Login")
        }
        .background(
            NavigationLink("", destination: MainCalculationView(), isActive: $isSignedUp)
        )
    }
    
    func login() {
            let success = userViewModel.login(username: username, password: password)

            if success {
                loginError = false
                isSignedUp = true
            } else {
                loginError = true
            }
        }

}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
