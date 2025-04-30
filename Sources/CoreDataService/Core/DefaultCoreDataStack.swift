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
    
    /// Initialization CoreData stack
    public init(configuration: CoreDataConfigurable) {
//        container = NSPersistentContainer(name: configuration.modelName)
//        guard let modelURL = Bundle.module.url(forResource: configuration.modelName, withExtension: "momd"),
//              let model = NSManagedObjectModel(contentsOf: modelURL) else {
//            throw CoreDataError.failedLoadingStore(error: <#T##any Error#>)
//        }
//
//        let container = NSPersistentContainer(name: configuration.modelName, managedObjectModel: model)
        for url in Bundle(for: DefaultCoreDataStack.self).urls(forResourcesWithExtension: "momd", subdirectory: nil) ?? [] {
            print("Found MOMD resource:", url)
        }
        guard let moduleURL = Bundle(for: DefaultCoreDataStack.self).url(forResource: configuration.modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: moduleURL) else {
            fatalError("CORE DATA BUNDLE ISSUE")
        }
        
        container = NSPersistentContainer(name: "TestModel", managedObjectModel: model)

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
    }

    /// Background context for performing long heavy tasks
    public func backgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        return context
    }
}
