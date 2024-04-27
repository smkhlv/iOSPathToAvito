import UIKit

public class Product {
    let id: UUID
    let shopId: UUID?
    
    let title: String
    let description: String
    let price: String
    let images: [UIImage]
    
    var isFavorite: Bool
    var isBucketInside: Bool
    
    init(
        id: UUID,
        shopId: UUID?,
        title: String,
        description: String,
        price: String,
        images: [UIImage],
        isFavorite: Bool = false,
        isBucketInside: Bool = false
    ) {
        self.id = id
        self.shopId = shopId
        self.title = title
        self.description = description
        self.price = price
        self.images = images
        self.isFavorite = isFavorite
        self.isBucketInside = isBucketInside
    }
}
