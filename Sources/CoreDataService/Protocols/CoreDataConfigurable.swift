//
//  CoreDataConfigurable.swift
//  CoreDataService
//
//  Created by Ihor Ilin on 28.04.2025.
//

import Foundation

/// `CoreDataConfigurable` defines the configuration properties required to initialize a Core Data stack.
/// This protocol allows customization of the Core Data environment, including the model name, storage type, and resource bundle.
public protocol CoreDataConfigurable {
    
    /// The name of the Core Data model (without the file extension).
    /// This name is used to locate the compiled `.momd` resource inside the provided bundle.
    var modelName: String { get set }

    /// A flag indicating whether the persistent store should use in-memory storage.
    /// Set to `true` for ephemeral data (e.g., during testing); `false` for persistent on-disk storage.
    var inMemory: Bool { get set }
    
    /// The bundle where the compiled Core Data model (`.momd`) is located.
    /// Typically `Bundle.main` in app targets or `Bundle.module` in Swift Package Manager.
    var bundle: Bundle { get set }
}
