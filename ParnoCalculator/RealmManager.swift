//
//  RealmManager.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    public let realm: Realm

    private init() {
        let config = Realm.Configuration(
                    schemaVersion: 2, // Increment this number when the schema changes
                    migrationBlock: { migration, oldSchemaVersion in
                        if oldSchemaVersion < 2 {
                            // Define your migration steps here
                            migration.enumerateObjects(ofType: UserRObj.className()) { oldObject, newObject in
                                // Add any migration steps for the 'isLoggedIn' property
                                newObject?["isLoggedIn"] = false // Example migration step
                            }
                        }
                    }
                )
        do {
            self.realm = try Realm(configuration: config)
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }

    // MARK: - User Queries

    func userExists(username: String, password: String) -> Bool {
        let user = realm.objects(UserRObj.self)
            .filter("username == %@ AND password == %@", username, password)
            .first
        return user != nil
    }

    func signUpUser(username: String, password: String) -> Bool {
           let newUser = UserRObj()
           newUser.username = username
           newUser.password = password

           do {
               try realm.write {
                   newUser.isLoggedIn = true
                   realm.add(newUser)
               }
               return true // Return true on successful signup
           } catch {
               print("Error adding a new user to Realm: \(error)")
               return false
           }
       }

    // MARK: - Other Realm Queries

    // Add methods for other Realm queries and operations as needed

    // Example: func fetchSomeData() -> Results<YourObjectType>? {
    //     return realm.objects(YourObjectType.self).filter("yourCondition")
    // }
}
