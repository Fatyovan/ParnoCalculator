//
//  RoomManager.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 10.10.24.
//

import Foundation
import CoreData

class RoomManager: ObservableObject {
    @Published var rooms: [RoomEntity] = []
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // Method to create a Room object
    func createRoom(roomName: String, house: HouseEntity) {
        let newRoom = RoomEntity(context: context)
        newRoom.roomName = roomName
        newRoom.house = house
        newRoom.roomDateCreated = Date().timeIntervalSince1970
        
        saveContext()
        fetchRooms(for: house)
    }
    
    // Method to fetch all rooms for a house
    func fetchRooms(for house: HouseEntity) {
        let fetchRequest: NSFetchRequest<RoomEntity> = RoomEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "house == %@", house)
        
        do {
            rooms = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching rooms: \(error)")
            rooms = []
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
