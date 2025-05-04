//
//  CoreDataService.swift
//  CoreDataService
//
//  Created by Ihor Ilin on 28.04.2025.
//

import CoreData

/// Public API for interacting with CoreData in a clean and generic way
public protocol CoreDataService {
    
    /// Fetch Swift models synchronously.
    ///
    /// - Parameters:
    ///   - modelType: The type of the Swift model to fetch.
    ///   - predicate: An optional predicate to filter the fetch request.
    ///   - sortDescriptors: An optional array of sort descriptors to order the results.
    /// - Throws: An error if the fetch fails.
    func fetchModels<Model: CoreDataRepresentable>(_ modelType: Model.Type,
                                                   predicate: NSPredicate?,
                                                   sortDescriptors: [NSSortDescriptor]?) throws -> [Model]

    /// Fetch CoreData entities directly (advanced usage, synchronous).
    ///
    /// - Parameters:
    ///   - entityType: The type of the CoreData entity to fetch.
    ///   - predicate: An optional predicate to filter the fetch request.
    ///   - sortDescriptors: An optional array of sort descriptors to order the results.
    /// - Throws: An error if the fetch fails.
    func fetchEntities<Entity: NSManagedObject>(_ entityType: Entity.Type,
                                                predicate: NSPredicate?,
                                                sortDescriptors: [NSSortDescriptor]?) throws -> [Entity]
    
    /// Fetch Swift models asynchronously
    /// - Parameters:
    ///   - modelType: The type of the Swift model to fetch.
    ///   - predicate: An optional predicate to filter the fetch request.
    ///   - sortDescriptors: An optional array of sort descriptors to order the results.
    ///   - completion: A completion handler called with the result containing either an array of models or a CoreDataError.
    func fetchModels<Model: CoreDataRepresentable>(_ modelType: Model.Type,
                                                   predicate: NSPredicate?,
                                                   sortDescriptors: [NSSortDescriptor]?,
                                                   completion: @escaping (Result<[Model], CoreDataError>) -> Void) async

    /// Fetch CoreData entities asynchronously (advanced usage)
    /// - Parameters:
    ///   - entityType: The type of the CoreData entity to fetch.
    ///   - predicate: An optional predicate to filter the fetch request.
    ///   - sortDescriptors: An optional array of sort descriptors to order the results.
    ///   - completion: A completion handler called with the result containing either an array of entities or a CoreDataError.
    func fetchEntities<Entity: NSManagedObject>(_ entityType: Entity.Type,
                                                predicate: NSPredicate?,
                                                sortDescriptors: [NSSortDescriptor]?,
                                                completion: @escaping (Result<[Entity], CoreDataError>) -> Void) async
    
    /// Create and insert Swift model into CoreData
    /// - Parameter model: The Swift model to insert into CoreData.
    /// - Throws: An error if the insertion fails.
    func insertModel<Model: CoreDataRepresentable>(_ model: Model) throws
    
    /// Insert CoreData entity directly
    /// - Parameter entity: The CoreData entity to insert into CoreData.
    /// - Throws: An error if the insertion fails.
    func insertEntity<Entity: NSManagedObject>(_ entity: Entity) throws

    /// Delete Swift model from CoreData
    /// - Parameter model: The Swift model to delete from CoreData.
    /// - Throws: An error if the deletion fails.
    func deleteModel<Model: CoreDataRepresentable>(_ model: Model) throws

    /// Delete CoreData entity directly
    /// - Parameter entity: The CoreData entity to delete.
    /// - Throws: An error if the deletion fails.
    func deleteEntity<Entity: NSManagedObject>(_ entity: Entity) throws

    /// Save current context
    /// - Throws: An error if saving the context fails.
    func save() throws
}
