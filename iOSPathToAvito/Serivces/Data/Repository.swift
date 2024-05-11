import CoreData

public enum FetchStrategy {
    case fromBD, fromBDAndJson
}

public protocol RepositoryProtocol {
    
    // Method to fetch shop data
    //func fetchShops() throws -> Result<[ShopDTO], LoaderError>
    
    // Method to fetch product data
    func fetchProducts(predicate: NSPredicate?,
                       fetchStrategy: FetchStrategy) -> Result<[Product], Error>
    
    func save()
}

public class Repository: RepositoryProtocol {
    
    private let loader: LoaderProtocol
    private let dataRequestService: DataServiceProtocol
    
    init(loader: LoaderProtocol, dataRequestService: DataServiceProtocol) {
        self.loader = loader
        self.dataRequestService = dataRequestService
    }
    
    public func save() {
        dataRequestService.save()
    }
    
    public func fetchProducts(
        predicate: NSPredicate? = nil,
        fetchStrategy: FetchStrategy
    ) -> Result<[Product], Error> {
        let objectsFromDB = dataRequestService.fetch(Product.self, predicate: predicate)
        
        if !objectsFromDB.isEmpty || fetchStrategy == .fromBD {
            return .success(objectsFromDB)
        } else {
            let objectsFromLocal = loader.fetchProducts()
            
            switch objectsFromLocal {
            case .success(let success):
                let convertedFromDTO: [Product] = success.compactMap {
                    
                    guard let product = dataRequestService.create(Product.self) else {
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
    }
}
