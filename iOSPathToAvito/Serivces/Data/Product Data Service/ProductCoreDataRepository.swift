import Foundation

public enum ProductCoreDataRepositoryError: Error {
    case fetchingError
}

public protocol ProductCoreDataRepositoryProtocol {
    func save()
}

public class ProductCoreDataRepository: ProductRepositoryFetchable, ProductRepositoryCreatable, ProductCoreDataRepositoryProtocol
{
        
    private let coreDataRequestService: CoreDataServiceProtocol
    
    init(coreDataRequestService: CoreDataServiceProtocol) {
        self.coreDataRequestService = coreDataRequestService
    }
    
    public func fetchProducts(predicate: NSPredicate) -> Result<[Product], any Error> {
        
        let products = coreDataRequestService.fetch(Product.self, predicate: predicate)
        
        if !products.isEmpty {
            return .success(products)
        } else {
            return .failure(ProductCoreDataRepositoryError.fetchingError)
        }
    }
    
    public func createProducts(products: [Product]) {
        // case when products created not from core data
        if let anyProduct = products.first,
           anyProduct.entity.properties.isEmpty {
            var productForSave = [Product]()
            products.forEach {
                guard let product = coreDataRequestService.create(Product.self) else {
                    return
                }
                
                product.id = $0.id
                product.shopId = $0.shopId
                product.title = $0.title
                product.productDescription = $0.description
                product.price = $0.price
                product.isFavorite = false
                product.isBucketInside = false
                
                productForSave.append(product)
            }
            coreDataRequestService.save()
        } else {
            coreDataRequestService.save()
        }
    }
    
    public func save() {
        coreDataRequestService.save()
    }
}

