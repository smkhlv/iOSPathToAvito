import UIKit
import CoreData

public class Shop: NSManagedObject {
    @NSManaged var id: UUID
    
    @NSManaged var city: String
    @NSManaged var adress: String
    @NSManaged var phoneNumber: Int
    @NSManaged var email: String
    @NSManaged var image: UIImage
    @NSManaged var products: [Product]
}
