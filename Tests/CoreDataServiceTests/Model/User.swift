//
//  File.swift
//  CoreDataService
//
//  Created by Ihor Ilin on 03.05.2025.
//

import CoreDataService
import CoreData
import Foundation

struct User: CoreDataRepresentable {
    var id: UUID?
    var name: String?
    
    init(id: UUID = UUID(), name: String?) {
        self.id = id
        self.name = name
    }
    
    init(from entity: UserEntity) {
        self.id = entity.id
        self.name = entity.name
    }
    
    func toEntity(in context: NSManagedObjectContext) -> UserEntity {
        let entity = UserEntity(context: context)
        
        entity.id = self.id
        entity.name = self.name
        
        return entity
    }
}
