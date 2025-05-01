
# CoreDataService

A lightweight, testable, thread-safe Core Data stack and CRUD service written in Swift, designed for modular integration as a Swift Package.

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
.package(url: "https://github.com/IhorIlin/CoreDataService.git", from: "0.1.0")
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
let config = DefaultCoreDataConfiguration(modelName: "MyModel")
let stack = DefaultCoreDataStack(configuration: config)
let service = DefaultCoreDataService(stack: stack)
```

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

### Delete

```swift
if let userToDelete = try service.fetchModels(User.self).first {
    try service.deleteModel(userToDelete)
    try service.save()
}
```

## License

MIT License
