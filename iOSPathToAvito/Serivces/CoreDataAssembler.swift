import CoreData

// Protocol defining properties required for assembling CoreData components
public protocol CoreDataAssemblerProtocol {
    var model: NSManagedObjectModel! { get }
    var context: NSManagedObjectContext? { get }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator? { get }
}

// Structure responsible for assembling CoreData components
public struct CoreDataAssembler {
    public var model: NSManagedObjectModel!
    public var context: NSManagedObjectContext?
    public var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    init() {
        setupCoreDataStack()
    }
    
    private mutating func setupCoreDataStack() {
        model = setupDataModel()
        let dataBaseURL = URL.documentsDirectory.appending(path: "DataBase.sqlite")
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        do {
            _ = try persistentStoreCoordinator?.addPersistentStore(type: .sqlite,
                                                                   at: dataBaseURL)
            context = NSManagedObjectContext.init(.mainQueue)
            context?.persistentStoreCoordinator = persistentStoreCoordinator
        } catch {
            debugPrint(error)
        }
    }
    
    private func setupDataModel() -> NSManagedObjectModel {
        
        let model = NSManagedObjectModel()
        
        let productEntity = NSEntityDescription()
        productEntity.name = String(describing: Product.self)
        productEntity.managedObjectClassName = NSStringFromClass(Product.self)
        
        // Attributes
        let productId = NSAttributeDescription()
        productId.name = "id"
        productId.attributeType = .UUIDAttributeType
        
        let productShopId = NSAttributeDescription()
        productShopId.name = "shopId"
        productShopId.attributeType = .UUIDAttributeType
        
        let productTitle = NSAttributeDescription()
        productTitle.name = "title"
        productTitle.attributeType = .stringAttributeType
        
        let productDescription = NSAttributeDescription()
        productDescription.name = "productDescription"
        productDescription.attributeType = .stringAttributeType
        
        let productPrice = NSAttributeDescription()
        productPrice.name = "price"
        productPrice.attributeType = .stringAttributeType
        
        let productIsFavorite = NSAttributeDescription()
        productIsFavorite.name = "_isFavorite"
        productIsFavorite.attributeType = .booleanAttributeType
        
        let productIsBucketInside = NSAttributeDescription()
        productIsBucketInside.name = "_isBucketInside"
        productIsBucketInside.attributeType = .booleanAttributeType
        
        // Set properties
        productEntity.properties = [
            productId,
            productShopId,
            productTitle,
            productDescription,
            productPrice,
            productIsFavorite,
            productIsBucketInside
        ]
        
        model.entities = [
            productEntity
        ]
        
        return model
    }
}
