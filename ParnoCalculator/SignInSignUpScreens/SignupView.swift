//
//  SignupView.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import SwiftUI
import RealmSwift

struct SignupView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var passwordsMatch = true
    
    @State private var isSignedUp = false
    let realmManager = RealmManager.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Create an Account")) {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: signUp) {
                            Text("Sign Up")
                        }
                        .frame(width: UIScreen.main.bounds.size.width / 2)
                        Spacer()
                    }
                }
                
                if !passwordsMatch {
                    Text("Passwords do not match").foregroundColor(.red)
                }
            }
            .navigationBarTitle("Sign Up")
            .background(
                NavigationLink("", destination: MainCalculationView(), isActive: $isSignedUp)
            )
        }
    }
    
    func signUp() {
        if password == confirmPassword {
            if realmManager.signUpUser(username: username, password: password) {
                isSignedUp = true
            } else {
                isSignedUp = false
            }
        } else {
            // Passwords do not match
            passwordsMatch = false
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
