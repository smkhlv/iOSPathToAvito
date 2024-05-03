import CoreData

public protocol CoreDataServiceProtocol {
    
    //associatedtype Object: DataObject
}

public protocol DS {
    
    func save()
    
    func create<T: NSManagedObject>(_ type: T.Type) -> T?
    
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T]
}

public class CoreDataService: DS {
    
    private var model: NSManagedObjectModel?
    private var context: NSManagedObjectContext?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    init() {
        setupCoreDataStack()
    }
    
    private func setupCoreDataStack() {
        model = setupDataModel()
        let dataBaseURL = URL.documentsDirectory.appending(path: "DataBase.sqlite")
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        
        do {
            let _ = try persistentStoreCoordinator?.addPersistentStore(type: .sqlite,
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
        
        let productImageId = NSAttributeDescription()
        productImageId.name = "productId"
        productImageId.attributeType = .UUIDAttributeType
        
        let productImageData = NSAttributeDescription()
        productImageData.name = "imageData"
        productImageData.attributeType = .binaryDataAttributeType
        
        // Relationships
        let productToImages = NSRelationshipDescription()
        productToImages.name = "images"
        productToImages.destinationEntity = productEntity
        productToImages.deleteRule = .cascadeDeleteRule
        
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
    
    public func save() {
        do {
            try context?.save()
        } catch {
            debugPrint(error)
        }
    }
    
    public func create<T: NSManagedObject>(_ type: T.Type) -> T? {
        guard let context,
              let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: T.self),
                                                                 in: context) else {
            return nil
        }
        let object = NSManagedObject(entity: entityDescription,
                                     insertInto: context)
        
        return object as? T
    }
    
    public func fetch<T: NSManagedObject>(_ type: T.Type) -> [T] {
        do {
            let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type))
            let fetchItem = try context?.fetch(fetchRequest)
            return fetchItem ?? []
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
