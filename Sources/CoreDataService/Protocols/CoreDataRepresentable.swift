//
//  CoreDataRepresentable.swift
//  CoreDataService
//
//  Created by Ihor Ilin on 28.04.2025.
//

import CoreData

/// A protocol that defines a bidirectional mapping between Swift structs and CoreData NSManagedObjects.
public protocol CoreDataRepresentable {
    associatedtype Entity: NSManagedObject

    /// Initialize Swift struct from a CoreData entity
    init(from entity: Entity)

    /// Create or update a CoreData entity from Swift struct
    func toEntity(in context: NSManagedObjectContext) -> Entity
}
