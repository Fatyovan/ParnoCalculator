//
//  InitialScreen.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import SwiftUI

struct InitialScreen: View {
    var body: some View {
          NavigationView {
              VStack {
                  Spacer()
                  Image("logo") // Replace with the name of your logo image asset
                      .resizable()
                      .frame(width: 150, height: 150)
                  Text("Heat calculator")
                      .font(.largeTitle)
                      .padding()
                      .background(Color.white)
                      .foregroundColor(.red)
                      .cornerRadius(10)
                  Spacer()
                  NavigationLink(destination: SignInView()) {
                      Text("Sign In")
                          .font(.headline)
                          .padding()
                          .frame(width: 200)
                          .background(Color.red)
                          .foregroundColor(.white)
                          .cornerRadius(10)
                  }

                  NavigationLink(destination: SignupView()) {
                      Text("Sign Up")
                          .font(.headline)
                          .padding()
                          .frame(width: 200)
                          .background(Color.white)
                          .foregroundColor(.red)
                          .cornerRadius(10)
                          .overlay(
                                      RoundedRectangle(cornerRadius: 10)
                                          .stroke(Color.red, lineWidth: 1) // Apply border with corner radius
                                  )
                  }
                  .padding()
                  Spacer()
              }
              .navigationBarTitle("") // Empty title to remove default navigation bar title
              .navigationBarHidden(true) // Hide the navigation bar
          }
      }
}

struct InitialScreen_Previews: PreviewProvider {
    static var previews: some View {
        InitialScreen()
    }
}
