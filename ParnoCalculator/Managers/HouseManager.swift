//
//  HouseManager.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 10.10.24.
//

import Foundation
import CoreData

class HouseManager: ObservableObject {
    let context: NSManagedObjectContext
    
    @Published var houses: [HouseEntity] = [] // Added to publish changes
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // Method to create a House object
    func createHouse(houseName: String, owner: UserEntity) {
        let newHouse = HouseEntity(context: context)
        newHouse.houseName = houseName
        newHouse.owner = owner
        newHouse.dateCreated = Date().timeIntervalSince1970
        
        saveContext()
        if let userId = owner.userId {
            fetchAllHouses(for: userId)
        }
    }
    
    // Method to fetch all houses
    func fetchAllHouses(for userId: UUID) {
        let fetchRequest: NSFetchRequest<HouseEntity> = HouseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "owner.userId == %@", userId as CVarArg)
        
        do {
            houses = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching houses: \(error)")
            houses = []
        }
    }
    
    func deleteHouse(house: HouseEntity) {
        context.delete(house)
        saveContext()
        
        if let userId = house.owner?.userId {
            fetchAllHouses(for: userId)
        }
    }
    
    // Save context method
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
