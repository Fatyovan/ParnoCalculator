//
//  WallManager.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12.10.24.
//

import Foundation
import CoreData

class WallManager: ObservableObject {
    @Published var walls: [WallEntity] = []
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchWalls(for room: RoomEntity) {
        let fetchRequest: NSFetchRequest<WallEntity> = WallEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "room == %@", room)
        
        do {
            walls = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching walls: \(error)")
            walls = []
        }
    }
    
    func deleteWall(wall: WallEntity) {
        
        context.delete(wall)
        saveContext()
        
        if let room = wall.room {
            fetchWalls(for: room)
        }
        
    }
    
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
