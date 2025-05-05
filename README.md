![Swift](https://img.shields.io/badge/swift-6.1%2B-orange)
![iOS](https://img.shields.io/badge/iOS-17%2B-blue)
![License](https://img.shields.io/github/license/IhorIlin/CoreDataService)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FIhorIlin%2FCoreDataService%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/IhorIlin/CoreDataService)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FIhorIlin%2FCoreDataService%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/IhorIlin/CoreDataService)

# CoreDataService

A lightweight, testable, thread-safe Core Data stack and CRUD service written in Swift, designed for modular integration as a Swift Package.

## Requirements 

- Swift 6.1+
- iOS 17+, macOS 14+

⚠️ Support for Swift 5.5+ / iOS 15+ is planned for a future release.

## Features

✅ Thread-safe Core Data stack using `NSPersistentContainer`  
✅ Shared `backgroundContext` and `viewContext` for concurrent operations  
✅ Insert, fetch, delete operations for any model conforming to `CoreDataRepresentable`  
✅ Support for in-memory and persistent stores  
✅ Modular, test-friendly design via protocols  
✅ Ready for use in apps and frameworks

## Installation

### Swift Package Manager

Add the following dependency in Xcode:

```
https://github.com/IhorIlin/CoreDataService.git
```

Or add manually to `Package.swift`:

```swift
.package(url: "https://github.com/IhorIlin/CoreDataService.git", from: "0.3.0")
```

## Usage

### Define your model

```swift
struct User: CoreDataRepresentable {
    let id: UUID
    let name: String

    init(from entity: UserEntity) {
        self.id = entity.id ?? UUID()
        self.name = entity.name ?? ""
    }

    func toEntity(in context: NSManagedObjectContext) -> UserEntity {
        let entity = UserEntity(context: context)
        entity.id = id
        entity.name = name
        return entity
    }
}
```

### Initialize the stack

```swift
let config = DefaultCoreDataConfiguration(modelName: "MyModel", inMemory: false, bundle: .main)
let stack = DefaultCoreDataStack(configuration: config)
let service = DefaultCoreDataService(stack: stack)
```

_Note: for unit tests, use `bundle: .module` instead of `.main`._

### Insert

```swift
let user = User(id: UUID(), name: "Ihor")
try service.insertModel(user)
try service.save()
```

### Fetch

```swift
let users = try service.fetchModels(User.self)
```

_Note: The `fetchModels(_:with:)` method requires an explicit model type to be specified._

### Fetch with custom fetch request

```swift
let fetchRequest = NSFetchRequest<UserEntity>(entityName: String(describing: UserEntity.self))
fetchRequest.predicate = NSPredicate(format: "name == %@", "Ihor")

let users = try await service.fetchModels(User.self, with: fetchRequest)
```

### Delete

```swift
if let userToDelete = try service.fetchModels(User.self).first {
    try service.deleteModel(userToDelete)
    try service.save()
}
```

## License

MIT License
