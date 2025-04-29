//
//  CoreDataService.swift
//  CoreDataService
//
//  Created by Ihor Ilin on 28.04.2025.
//

import CoreData

/// Public API for interacting with CoreData in a clean and generic way
public protocol CoreDataService {
    
    /// Fetch Swift models
    func fetchModels<Model: CoreDataRepresentable>(_ modelType: Model.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> [Model]

    /// Fetch CoreData entities directly (advanced usage)
    func fetchEntities<Entity: NSManagedObject>(_ entityType: Entity.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> [Entity]

    /// Create and insert Swift model into CoreData
    func insertModel<Model: CoreDataRepresentable>(_ model: Model) throws

    /// Delete Swift model from CoreData
    func deleteModel<Model: CoreDataRepresentable>(_ model: Model) throws

    /// Delete CoreData entity directly
    func deleteEntity<Entity: NSManagedObject>(_ entity: Entity) throws

    /// Save current context
    func save() throws
}
