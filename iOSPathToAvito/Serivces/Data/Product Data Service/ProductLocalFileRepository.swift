import Foundation

public class ProductLocalFileRepository: ProductRepository {

    private let localLoader: LocalLoaderProtocol
    private let coreDataService: CoreDataServiceProtocol
    
    init(localLoader: LocalLoaderProtocol, coreDataService: CoreDataServiceProtocol) {
        self.localLoader = localLoader
        self.coreDataService = coreDataService
    }
    
    public func fetchProducts(predicate: NSPredicate) -> Result<[Product], any Error> {
        
        let objectsFromLocal = localLoader.fetchProducts()
        
        switch objectsFromLocal {
        case .success(let success):
            let convertedFromDTO: [Product] = success.compactMap {
                
                guard let product = coreDataService.create(Product.self) else {
                    return nil
                }
                
                product.id = $0.id
                product.shopId = $0.shopId
                product.title = $0.title
                product.productDescription = $0.description
                product.price = $0.price
                product.isFavorite = false
                product.isBucketInside = false
                
                return product
            }
            return .success(convertedFromDTO)
        case .failure(let failure):
            debugPrint(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    // We shoudn't create/update these
    public func createProducts(products: [Product]) { }
    
    public func updateProduct(product: Product) { }
}
