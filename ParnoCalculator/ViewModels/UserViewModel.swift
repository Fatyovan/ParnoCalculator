//
//  UserViewModel.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import Foundation
import RealmSwift

class UserViewModel: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
    
    init() {
        // Query Realm to check if a user is logged in
        if let user = try? RealmManager.shared.realm.objects(UserRObj.self).first, user.isLoggedIn {
            isUserLoggedIn = true
        }
    }
    
    func login(username: String, password: String) -> Bool {
        
        if RealmManager.shared.userExists(username: username, password: password) {
                if let user = try? Realm().objects(UserRObj.self).first {
                    do {
                        let realm = try Realm()
                        try realm.write {
                            user.isLoggedIn = true
                        }
                        isUserLoggedIn = true
                        return true // Return true on successful login
                    } catch {
                        print("Error updating user login status in Realm: \(error)")
                    }
                }
            }

            return false
    }
        
    
    func logout() {
        if let user = try? Realm().objects(UserRObj.self).first {
            do {
                let realm = try Realm()
                try realm.write {
                    user.isLoggedIn = false
                }
                isUserLoggedIn = false
            } catch {
                print("Error updating user login status in Realm: \(error)")
            }
        }
    }
}
