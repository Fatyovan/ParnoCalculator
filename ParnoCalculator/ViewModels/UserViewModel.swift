//
//  UserViewModel.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import Foundation
import CoreData

class UserViewModel: ObservableObject {
    @Published var isUserLoggedIn = false
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var currentUser: UserEntity?
    
    private var viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        checkIfUserIsLoggedIn()
    }

    // Sign Up: Create new user and save in Core Data
    func signUp(username: String, password: String) {
        let newUser = UserEntity(context: viewContext)
        newUser.userName = username
        newUser.password = password
        newUser.userId = UUID() // Generate a new UUID for the user

        do {
            try viewContext.save()
            self.currentUser = newUser
            isUserLoggedIn = true
        } catch {
            print("Failed to save user: \(error)")
        }
    }

    // Log In: Check if the user exists in Core Data
    func logIn(username: String, password: String) -> Bool {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND password == %@", username, password)

        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first {
                self.currentUser = user // Retrieve the userId
                isUserLoggedIn = true
                return true
            }
        } catch {
            print("Failed to fetch user: \(error)")
        }
        return false
    }

    // Log Out: Simply reset the userId and isUserLoggedIn
    func logOut() {
        self.currentUser = nil // Clear userId on logout
        isUserLoggedIn = false
    }

    // Check if a user is already logged in
    private func checkIfUserIsLoggedIn() {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first {
                self.username = user.userName ?? ""
                self.currentUser = user // Set userId from existing user
                self.isUserLoggedIn = true
            } else {
                self.isUserLoggedIn = false
            }
        } catch {
            print("Failed to check if user is logged in: \(error)")
        }
    }
}
