//
//  SignupView.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import SwiftUI

struct SignupView: View {
    
    
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isSignUp = false
    @State private var confirmPassword = ""
    @State private var passwordsMatch = true
    
    
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
                NavigationLink("", destination: MainCalculationView(), isActive: $userViewModel.isUserLoggedIn)
            )
        }
    }
    
    func signUp() {
        if password == confirmPassword {
            userViewModel.signUp(username: username, password: password)
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
