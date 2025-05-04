//
//  DefaultCoreDataConfiguration.swift
//  CoreDataService
//
//  Created by Ihor Ilin on 28.04.2025.
//

import Foundation

/// `DefaultCoreDataConfiguration` provides configuration settings for initializing a Core Data stack.
/// Conforms to `CoreDataConfigurable` protocol to supply required properties.
public struct DefaultCoreDataConfiguration: CoreDataConfigurable {
    
    /// The name of the Core Data model (without file extension).
    public var modelName: String
    
    /// A Boolean value indicating whether the store should be in-memory.
    /// Set to `true` to use an in-memory store (useful for testing); `false` for persistent storage.
    public var inMemory: Bool
    
    /// The bundle where the compiled Core Data model (`.momd`) is located.
    /// Defaults to `Bundle.main`, but can be customized (e.g., for test bundles).
    public var bundle: Bundle
    
    /// Initializes a new configuration for the Core Data stack.
    /// - Parameters:
    ///   - modelName: The name of the Core Data model (without file extension).
    ///   - inMemory: Whether to use an in-memory store.
    ///   - bundle: The bundle containing the model; defaults to `Bundle.main`.
    public init(modelName: String, inMemory: Bool = false, bundle: Bundle = .main) {
        self.modelName = modelName
        self.inMemory = inMemory
        self.bundle = bundle
    }
}
