import CoreData

// Protocol defining methods for interacting with data services
public protocol DataServiceProtocol {
    // Method to save changes to the data context
    func save()
    
    // Method to create a new managed object of a given type
    func create<T: NSManagedObject>(_ type: T.Type) -> T?
    
    // Method to fetch managed objects of a given type
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T]
}

public class DataRequestService: DataServiceProtocol {
    
    let coreDataAssembler: CoreDataAssembler
    
    init(coreDataAssembler: CoreDataAssembler) {
        self.coreDataAssembler = coreDataAssembler
    }
    
    public func save() {
        do {
            try coreDataAssembler.context?.save()
        } catch {
            debugPrint(error)
        }
    }
    
    public func create<T: NSManagedObject>(_ type: T.Type) -> T? {
        guard let context = coreDataAssembler.context,
              let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: T.self),
                                                                 in: context) else {
            return nil
        }
        let object = NSManagedObject(entity: entityDescription,
                                     insertInto: coreDataAssembler.context)
        
        return object as? T
    }
    
    public func fetch<T: NSManagedObject>(_ type: T.Type) -> [T] {
        do {
            let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type))
            let fetchItem = try coreDataAssembler.context?.fetch(fetchRequest)
            return fetchItem ?? []
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
