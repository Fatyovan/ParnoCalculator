//
//  HouseRObj.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import Foundation
import RealmSwift

class HouseRObj: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name = ""
    // Add any other properties related to the house
}
