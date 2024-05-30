import Foundation

public protocol ProductRepositoryFetchable {
    
    func fetchProducts(predicate: NSPredicate) -> Result<[Product], Error>
}

public protocol ProductRepositoryCreatable {
    func createProducts(products: [Product])
}

public protocol ProductRepositoryUpdatable {
    func updateProduct(product: Product)
}

public typealias ProductRepository = ProductRepositoryFetchable & ProductRepositoryCreatable & ProductRepositoryUpdatable
