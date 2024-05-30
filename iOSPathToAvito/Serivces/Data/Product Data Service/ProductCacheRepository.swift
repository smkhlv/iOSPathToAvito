import Foundation

public enum ProductCacheRepositoryError: Error {
    case fetchingError, updateError, noPredicate
}

public class ProductCacheRepository: ProductRepository {

    private var products = [Product]()
    
    public func fetchProducts(predicate: NSPredicate) -> Result<[Product], any Error> {
        
        let filteredProducts = products.filter { predicate.evaluate(with: $0) }

        return .success(filteredProducts)
    }
    
    public func createProducts(products: [Product]) {
        self.products = products
    }
    
    public func updateProduct(product: Product) {
        guard let id = products.firstIndex(where: { $0.id == product.id }) else {
            return
        }
        
        products[id] = product
    }
}
