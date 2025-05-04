//
//  DefaultCoreDataStack.swift
//  CoreDataService
//
//  Created by Ihor Ilin on 28.04.2025.
//

import CoreData

public final class DefaultCoreDataStack: CoreDataStack {

    /// Persistent container
    private let container: NSPersistentContainer

    /// view context for updating UI 
    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    /// Background context for performing long heavy tasks
    public var backgroundContext: NSManagedObjectContext
    
    /// Initialization CoreData stack
    public init(configuration: CoreDataConfigurable) {
        guard
            let url = configuration.bundle.url(forResource: configuration.modelName, withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: url) else {
            
            fatalError("CoreDataStack failed to load model \(configuration.modelName)")
        }
        
        container = NSPersistentContainer(name: configuration.modelName, managedObjectModel: model)
        
        if configuration.inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreDataStack failed to load store: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        backgroundContext = container.newBackgroundContext()
        
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}
