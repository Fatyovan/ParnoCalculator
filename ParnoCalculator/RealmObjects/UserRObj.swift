//
//  UserRObj.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import Foundation
import RealmSwift


class UserRObj: Object, ObjectKeyIdentifiable {
    @Persisted var username = ""
    @Persisted var password = ""
    @Persisted var language = ""
    @Persisted var isLoggedIn = false
    let houses = RealmSwift.List<HouseRObj>()
}
