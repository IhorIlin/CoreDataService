//
//  DefaultCoreDataConfiguration.swift
//  CoreDataService
//
//  Created by Ihor Ilin on 28.04.2025.
//

import Foundation

/// Struct is using by `CoreDataStack` for initialization 
struct DefaultCoreDataConfiguration: CoreDataConfigurable {
    
    /// `modelName` represent model name of CoreData model
    var modelName: String
    
    /// `inMemory` bool value represent memory type `inMemory = true` will not use storage
    var inMemory: Bool
}
