//
//  DefaultCoreDataService.swift
//  CoreDataService
//
//  Created by Ihor Ilin on 29.04.2025.
//

import CoreData

public final class DefaultCoreDataService: CoreDataService {
    
    // MARK: - Private Properties
    
    /// CoreData stack used for context management.
    private var coreDataStack: CoreDataStack
    
    /// View (main/UI) context for read/write on main thread.
    private var viewContext: NSManagedObjectContext {
        coreDataStack.viewContext
    }
    
    /// Background context for background operations.
    private var backgroundContext: NSManagedObjectContext {
        coreDataStack.backgroundContext
    }
    
    // MARK: - Init
    
    public init(stack: CoreDataStack) {
        coreDataStack = stack
    }
    
    // MARK: - Sync Fetch
    
    /// Fetches models synchronously using the view context.
    /// - Parameters:
    ///   - modelType: The type of model conforming to CoreDataRepresentable.
    ///   - predicate: Optional NSPredicate to filter results.
    ///   - sortDescriptors: Optional array of NSSortDescriptor to sort results.
    /// - Throws: CoreDataError if fetching fails.
    /// - Returns: Array of fetched models.
    public func fetchModels<Model: CoreDataRepresentable>(_ modelType: Model.Type,
                                                          predicate: NSPredicate?,
                                                          sortDescriptors: [NSSortDescriptor]?) throws -> [Model] {
        
        var fetchError: Error?
        var models: [Model] = []
        
        viewContext.performAndWait {
            let fetchRequest = NSFetchRequest<Model.Entity>(entityName: String(describing: Model.Entity.self))
            
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors
            
            do {
                let entities = try viewContext.fetch(fetchRequest)
                
                models = entities.map { Model(from: $0) }
            } catch {
                fetchError = CoreDataError.failedFetchingEntities(error: error)
            }
        }
        
        if let error = fetchError {
            throw error
        }
        
        return models
    }
    
    /// Fetches Core Data entities synchronously using the view context.
    /// - Parameters:
    ///   - entityType: The NSManagedObject subclass type.
    ///   - predicate: Optional NSPredicate to filter results.
    ///   - sortDescriptors: Optional array of NSSortDescriptor to sort results.
    /// - Throws: CoreDataError if fetching fails.
    /// - Returns: Array of fetched entities.
    public func fetchEntities<Entity: NSManagedObject>(_ entityType: Entity.Type,
                                      predicate: NSPredicate?,
                                      sortDescriptors: [NSSortDescriptor]?) throws -> [Entity] {
        var fetchError: Error?
        var entities: [Entity] = []
        
        viewContext.performAndWait {
            let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
                
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors
            
            do {
                entities = try viewContext.fetch(fetchRequest)
            } catch {
                fetchError = CoreDataError.failedFetchingEntities(error: error)
            }
        }
        
        if let error = fetchError {
            throw error
        }
        
        return entities
    }
    
    // MARK: - Async Fetch
    
    /// Asynchronously fetches models using the view context.
    /// - Parameters:
    ///   - modelType: The type of model conforming to CoreDataRepresentable.
    ///   - predicate: Optional NSPredicate to filter results.
    ///   - sortDescriptors: Optional array of NSSortDescriptor to sort results.
    /// - Throws: CoreDataError if fetching fails.
    /// - Returns: Array of fetched models.
    public func fetchModels<Model: CoreDataRepresentable>(_ modelType: Model.Type,
                                                          predicate: NSPredicate?,
                                                          sortDescriptors: [NSSortDescriptor]?) async throws -> [Model] {
        try await self.viewContext.perform {
            let fetchRequest = NSFetchRequest<Model.Entity>(entityName: String(describing: Model.Entity.self))
            
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors
            
            do {
                let entities = try self.viewContext.fetch(fetchRequest)
                
                let models = entities.map { Model(from: $0) }
                
                return models
            } catch {
                throw CoreDataError.failedFetchingEntities(error: error)
            }
        }
    }
    
    /// Asynchronously fetches entities using the view context.
    /// - Parameters:
    ///   - entityType: The NSManagedObject subclass type.
    ///   - predicate: Optional NSPredicate to filter results.
    ///   - sortDescriptors: Optional array of NSSortDescriptor to sort results.
    /// - Throws: CoreDataError if fetching fails.
    /// - Returns: Array of fetched entities.
    public func fetchEntities<Entity: NSManagedObject>(_ entityType: Entity.Type,
                                                       predicate: NSPredicate?,
                                                       sortDescriptors: [NSSortDescriptor]?) async throws -> [Entity] {
        try await self.viewContext.perform {
            let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
            
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors
            
            do {
                let entities = try self.viewContext.fetch(fetchRequest)
                
                return entities
            } catch {
                throw CoreDataError.failedFetchingEntities(error: error)
            }
        }
    }
    
    /// Asynchronously fetches models using a custom NSFetchRequest.
    /// - Parameter fetchRequest: A configured NSFetchRequest to use for fetching.
    /// - Throws: CoreDataError if fetching fails.
    /// - Returns: An array of fetched models.
    public func fetchModels<Model: CoreDataRepresentable>(_ modelType: Model.Type, with fetchRequest: NSFetchRequest<Model.Entity>) async throws -> [Model] {
        try await viewContext.perform {
            do {
                let entities = try self.viewContext.fetch(fetchRequest)
                
                return entities.map { Model(from: $0) }
            } catch {
                throw CoreDataError.failedFetchingEntities(error: error)
            }
        }
    }
    
    /// Asynchronously fetches entities using a custom NSFetchRequest.
    /// - Parameter fetchRequest: A configured NSFetchRequest to use for fetching.
    /// - Throws: CoreDataError if fetching fails.
    /// - Returns: An array of fetched entities.
    public func fetchEntities<Entity: NSManagedObject>(with fetchRequest: NSFetchRequest<Entity>) async throws -> [Entity] {
        try await viewContext.perform {
            do {
                let entities = try self.viewContext.fetch(fetchRequest)
                
                return entities
            } catch {
                throw CoreDataError.failedFetchingEntities(error: error)
            }
        }
    }
    
    // MARK: - Insert
    
    /// Inserts a new model using the background context.
    /// - Parameter model: The model conforming to CoreDataRepresentable to insert.
    /// - Throws: CoreDataError if saving the context fails.
    public func insertModel<Model: CoreDataRepresentable>(_ model: Model) throws {
        var insertError: Error?
        
        backgroundContext.performAndWait {
            _ = model.toEntity(in: backgroundContext)
            
            do {
                try backgroundContext.save()
            } catch {
                insertError = CoreDataError.failedSavingContext(error: error)
            }
        }
        
        if let error = insertError {
            throw CoreDataError.failedSavingContext(error: error)
        }
    }
    
    public func insertEntity<Entity: NSManagedObject>(_ entity: Entity) throws {
        var insertError: Error?
        
        backgroundContext.performAndWait {
            backgroundContext.insert(entity)
            do {
                try backgroundContext.save()
            } catch {
                insertError = error
            }
        }
        
        if let error = insertError {
            throw error
        }
    }
    
    // MARK: - Delete
    
    /// Deletes the given model using the background context.
    /// - Parameter model: The model conforming to CoreDataRepresentable to delete.
    /// - Throws: CoreDataError if deleting or saving fails.
    public func deleteModel<Model: CoreDataRepresentable>(_ model: Model) throws {
        var deleteError: Error?
        
        backgroundContext.performAndWait {
            backgroundContext.delete(model.toEntity(in: backgroundContext))
            
            do {
                try backgroundContext.save()
            } catch {
                deleteError = CoreDataError.failedDeletingEntity(error: error)
            }
        }
        
        if let error = deleteError {
            throw error
        }
    }
    
    /// Deletes the given entity using the background context.
    /// - Parameter entity: The NSManagedObject entity to delete.
    /// - Throws: CoreDataError if deleting or saving fails.
    public func deleteEntity<Entity: NSManagedObject>(_ entity: Entity) throws {
        var deleteError: Error?
        
        backgroundContext.performAndWait {
            backgroundContext.delete(entity)
            
            do {
                try backgroundContext.save()
            } catch {
                deleteError = CoreDataError.failedDeletingEntity(error: error)
            }
        }
        
        if let error = deleteError {
            throw error
        }
    }
    
    // MARK: - Save
    
    /// Saves the view (main/UI) context.
    /// - Throws: CoreDataError if saving the context fails.
    public func save() throws {
        var saveError: Error?
        
        viewContext.performAndWait {
            do {
                try viewContext.save()
            } catch {
                saveError = CoreDataError.failedSavingContext(error: error)
            }
        }
        
        if let error = saveError {
            throw error
        }
    }
}
