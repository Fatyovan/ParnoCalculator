//
//  ContentView.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        if userViewModel.isUserLoggedIn {
            MainCalculationView()
                .environmentObject(userViewModel)
        } else {
            InitialScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
