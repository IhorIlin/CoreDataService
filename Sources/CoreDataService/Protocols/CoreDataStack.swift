//
//  CoreDataService.swift
//  CoreDataService
//
//  Created by Ihor Ilin on 28.04.2025.
//

import CoreData

/// Protocol `CoreDataStack` define interface for access main contexts
public protocol CoreDataStack {
    
    /// `viewContext` view context for working with UI
    var viewContext: NSManagedObjectContext { get }
    
    /// `backgroundContext` function returns new background context for performing long heavy tasks
    var backgroundContext: NSManagedObjectContext { get }
}
