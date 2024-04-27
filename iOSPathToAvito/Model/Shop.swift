import UIKit

public class Shop {
    let id: UUID
    
    let city: String
    let adress: String
    let phoneNumber: Int
    let email: String
    let image: UIImage
    let products: [Product]
    
    init(
        id: UUID,
        city: String,
        adress: String,
        phoneNumber: Int,
        email: String,
        image: UIImage,
        products: [Product]
    ) {
        self.id = id
        self.city = city
        self.adress = adress
        self.phoneNumber = phoneNumber
        self.email = email
        self.image = image
        self.products = products
    }
}
