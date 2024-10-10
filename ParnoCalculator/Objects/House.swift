//
//  House.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 10.10.24.
//

import Foundation
import CoreData

class House: ObservableObject {
    let houseName: String
    let userId: Int64
    
    init(houseName: String, userId: Int64) {
        self.houseName = houseName
        self.userId = userId
    }
}
