

import Foundation
import CoreData
final class CoreDataManager : ObservableObject{
    static let shared = CoreDataManager()
    var persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer =  NSPersistentContainer(name: "TestApp")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to laod DB \(error)")
            }
        }
        let description = NSPersistentStoreDescription()
           description.shouldMigrateStoreAutomatically = true
           description.shouldInferMappingModelAutomatically = true
        persistentContainer.persistentStoreDescriptions =  [description]
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.viewContext.undoManager = nil
        persistentContainer.viewContext.shouldDeleteInaccessibleFaults = true
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
                
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
