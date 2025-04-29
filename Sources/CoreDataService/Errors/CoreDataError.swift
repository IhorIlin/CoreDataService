//
//  CoreDataError.swift
//  CoreDataService
//
//  Created by Ihor Ilin on 28.04.2025.
//

import Foundation

/// An enumeration representing various Core Data-related errors.
public enum CoreDataError: Error, LocalizedError {
    /// Thrown when the persistent store fails to load.
    case failedLoadingStore(error: Error)
    
    /// Thrown when a context fails to save changes.
    case failedSavingContext(error: Error)
    
    /// Thrown when entities cannot be fetched from the persistent store.
    case failedFetchingEntities(error: Error)
    
    /// Thrown when an entity cannot be deleted from the persistent store.
    case failedDeletingEntity(error: Error)

    public var errorDescription: String? {
        switch self {
        case .failedLoadingStore(let error):
            return "Failed to load persistent stores: \(error.localizedDescription)"
        case .failedSavingContext(let error):
            return "Failed to save context: \(error.localizedDescription)"
        case .failedFetchingEntities(let error):
            return "Failed to fetch entities: \(error.localizedDescription)"
        case .failedDeletingEntity(let error):
            return "Failed to delete entity: \(error.localizedDescription)"
        }
    }
}
