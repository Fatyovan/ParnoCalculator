//
//  CoreDataStruct.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 10.10.24.
//

import CoreData

struct CoreDataStack {
    static let shared = CoreDataStack()
    
    // Persistent Container
    let persistentContainer: NSPersistentContainer
    
    // Init Persistent Container
    private init() {
        persistentContainer = NSPersistentContainer(name: "MainDataModel")
        
        let storeURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("MainDataModel.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load Core Data stack: \(error)")
            }
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Access to Managed Object Context
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
