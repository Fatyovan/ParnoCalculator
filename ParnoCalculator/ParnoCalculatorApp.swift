//
//  ParnoCalculatorApp.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import SwiftUI

@main
struct ParnoCalculatorApp: App {
    let persistentContainer = CoreDataStack.shared.persistentContainer

    @StateObject private var userViewModel = UserViewModel(viewContext: CoreDataStack.shared.persistentContainer.viewContext)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .environment(\.managedObjectContext, persistentContainer.viewContext)
                .preferredColorScheme(.light)
        }
    }
}
