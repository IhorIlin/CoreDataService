import XCTest
@testable import CoreDataService

final class CoreDataServiceTests: XCTestCase {
    
    private var service: CoreDataService!
    private var stack: CoreDataStack!
    
    override func setUpWithError() throws {
        let configuration = DefaultCoreDataConfiguration(modelName: "TestModel", inMemory: true, bundle: .module)
        
        stack = DefaultCoreDataStack(configuration: configuration)
        
        service = DefaultCoreDataService(stack: stack)
    }
    
    func testInsertModel() {
        XCTAssertNoThrow(try service.insertModel(User(name: "Ihor")))
        
        let models = try? service.fetchModels(User.self, predicate: nil, sortDescriptors: nil)
        
        XCTAssertNotNil(models)
        
        XCTAssertFalse(models?.isEmpty ?? true)
    }
    
    func testInsertEntity() {
        let entity = UserEntity(context: stack.backgroundContext)
        
        entity.id = UUID()
        entity.name = "Ihor"
        
        XCTAssertNoThrow(try service.insertEntity(entity))
        
        let models = try? service.fetchModels(User.self, predicate: nil, sortDescriptors: nil)
        
        XCTAssertNotNil(models)
        
        XCTAssertFalse(models?.isEmpty ?? true)
    }
    
    func testFetchModel() {
        XCTAssertNoThrow(try service.insertModel(User(name: "John")))
        XCTAssertNoThrow(try service.insertModel(User(name: "Bill")))
        XCTAssertNoThrow(try service.insertModel(User(name: "Fenix")))
        
        let models = try? service.fetchModels(User.self, predicate: nil, sortDescriptors: nil)
        
        XCTAssertNotNil(models)
        
        XCTAssertFalse(models?.isEmpty ?? true)
        
        XCTAssertEqual(models?.count, 3)
    }
    
    func testFetchEntity() {
        let entity1 = UserEntity(context: stack.backgroundContext)
        
        entity1.id = UUID()
        entity1.name = "Ihor"
        
        let entity2 = UserEntity(context: stack.backgroundContext)
        
        entity2.id = UUID()
        entity2.name = "Bill"
        
        let entity3 = UserEntity(context: stack.backgroundContext)
        
        entity3.id = UUID()
        entity3.name = "John"
        
        XCTAssertNoThrow(try service.insertEntity(entity1))
        XCTAssertNoThrow(try service.insertEntity(entity2))
        XCTAssertNoThrow(try service.insertEntity(entity3))
        
        let models = try? service.fetchEntities(UserEntity.self, predicate: nil, sortDescriptors: nil)
        
        XCTAssertNotNil(models)
        
        XCTAssertFalse(models?.isEmpty ?? true)
        
        XCTAssertEqual(models?.count, 3)
    }
    
    func testDeleteModel() {
        let model1 = User(name: "John")
        let model2 = User(name: "Bill")
        let model3 = User(name: "Fenix")
        
        XCTAssertNoThrow(try service.insertModel(model1))
        XCTAssertNoThrow(try service.insertModel(model2))
        XCTAssertNoThrow(try service.insertModel(model3))
        
        let models = try? service.fetchModels(User.self, predicate: nil, sortDescriptors: nil)
        
        XCTAssertNotNil(models)
        
        XCTAssertFalse(models?.isEmpty ?? true)
        
        XCTAssertEqual(models?.count, 3)
        
        XCTAssertNoThrow(try service.deleteModel(model1))
        
        var updatedModels = try? service.fetchModels(User.self, predicate: nil, sortDescriptors: nil)
        
        updatedModels?.removeAll { $0.id == model1.id }
        
        XCTAssertEqual(updatedModels?.count, 2)
        
        XCTAssertFalse(updatedModels?.contains { $0.id == model1.id } ?? true)
    }
    
    func testDeleteEntity() {
        let entity1 = UserEntity(context: stack.backgroundContext)
        
        entity1.id = UUID()
        entity1.name = "Ihor"
        
        let entity2 = UserEntity(context: stack.backgroundContext)
        
        entity2.id = UUID()
        entity2.name = "Bill"
        
        let entity3 = UserEntity(context: stack.backgroundContext)
        
        entity3.id = UUID()
        entity3.name = "John"
        
        XCTAssertNoThrow(try service.insertEntity(entity1))
        XCTAssertNoThrow(try service.insertEntity(entity2))
        XCTAssertNoThrow(try service.insertEntity(entity3))
        
        let models = try? service.fetchEntities(UserEntity.self, predicate: nil, sortDescriptors: nil)
        
        XCTAssertNotNil(models)
        
        XCTAssertFalse(models?.isEmpty ?? true)
        
        XCTAssertEqual(models?.count, 3)
        
        XCTAssertNoThrow(try service.deleteEntity(entity3))
        
        var updatedModels = try? service.fetchEntities(UserEntity.self, predicate: nil, sortDescriptors: nil)
        
        updatedModels?.removeAll { $0.id == entity3.id }
        
        XCTAssertEqual(updatedModels?.count, 2)
        
        XCTAssertFalse(updatedModels?.contains { $0.id == entity3.id } ?? true)
    }
}
