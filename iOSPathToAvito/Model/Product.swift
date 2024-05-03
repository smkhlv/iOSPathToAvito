import UIKit
import CoreData

public class Product: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var shopId: UUID?
    
    @NSManaged var title: String?
    @NSManaged var productDescription: String?
    @NSManaged var price: String?
    
    @NSManaged private var _isFavorite: NSNumber?
    @NSManaged private var _isBucketInside: NSNumber?
    
    public var isFavorite: Bool {
        get {
            return _isFavorite?.boolValue ?? false
        }
        set {
            _isFavorite = NSNumber(booleanLiteral: newValue)
        }
    }
    
    public var isBucketInside: Bool {
        get {
            return _isBucketInside?.boolValue ?? false
        }
        set {
            _isBucketInside = NSNumber(booleanLiteral: newValue)
        }
    }
}
