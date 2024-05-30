import Foundation
//public protocol ProductCacheObserver: AnyObject {
//    func productDidUpdated(product: Product)
//}

public enum DataStrategy {
    case fromCache, fromBD, fromJson
}

public protocol ProductDataServiceProtocol: ProductDifferencable {
    
    func createProducts(
        strategy: DataStrategy,
        products: [Product]
    )
    
    func updateProduct(
        strategy: DataStrategy,
        product: Product
    )
    
    func fetchProducts(
        strategy: DataStrategy,
        predicate: NSPredicate
    ) -> Result<[Product], Error>
}

public class ProductDataService: ProductDataServiceProtocol {

    private let productLocalFileRepository: ProductLocalFileRepository
    private let productCoreDataRepository: ProductCoreDataRepository
    private let productCacheRepository: ProductCacheRepository
    
    init(productLocalFileRepository: ProductLocalFileRepository, 
         productCoreDataRepository: ProductCoreDataRepository,
         productCacheRepository: ProductCacheRepository) {
        self.productLocalFileRepository = productLocalFileRepository
        self.productCoreDataRepository = productCoreDataRepository
        self.productCacheRepository = productCacheRepository
    }

    public func createProducts(strategy: DataStrategy, products: [Product]) {
        switch strategy {
        case .fromBD:
            productCoreDataRepository.createProducts(products: products)
        case .fromJson:
            productLocalFileRepository.createProducts(products: products)
        case .fromCache:
            productCacheRepository.createProducts(products: products)
        }
    }
    
    public func updateProduct(strategy: DataStrategy, product: Product) {
        switch strategy {
        case .fromBD:
            productCoreDataRepository.save()
        case .fromJson:
            productLocalFileRepository.updateProduct(product: product)
        case .fromCache:
            productCacheRepository.updateProduct(product: product)
        }
    }
    
    public func fetchProducts(strategy: DataStrategy, predicate: NSPredicate) -> Result<[Product], Error> {
        switch strategy {
        case .fromCache:
            return productCacheRepository.fetchProducts(predicate: predicate)
        case .fromBD:
            return productCoreDataRepository.fetchProducts(predicate: predicate)
        case .fromJson:
            return productLocalFileRepository.fetchProducts(predicate: predicate)
        }
    }
}
