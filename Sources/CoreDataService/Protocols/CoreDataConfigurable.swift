//
//  CoreDataConfigurable.swift
//  CoreDataService
//
//  Created by Ihor Ilin on 28.04.2025.
//

import Foundation

/// A protocol that defines the configuration required to initialize a Core Data stack.
protocol CoreDataConfigurable {
    /// The name of the Core Data model (xcdatamodeld file).
    var modelName: String { get set }

    /// A flag indicating whether the persistent store should be in-memory (useful for testing).
    var inMemory: Bool { get set }
}
