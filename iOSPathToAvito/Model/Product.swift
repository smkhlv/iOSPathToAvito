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
    
    // Computed property to expose whether the product is marked as favorite
    public var isFavorite: Bool {
        get {
            return _isFavorite?.boolValue ?? false
        }
        set {
            _isFavorite = NSNumber(booleanLiteral: newValue)
        }
    }
    
    // Computed property to expose whether the product is inside the bucket
    public var isBucketInside: Bool {
        get {
            return _isBucketInside?.boolValue ?? false
        }
        set {
            _isBucketInside = NSNumber(booleanLiteral: newValue)
        }
    }
}
