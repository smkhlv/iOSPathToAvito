import Foundation

// Protocol defining the input methods for Product Detail Interactor
public protocol ProductDetailInteractorInput {
    
    func fetchProduct()
    
    func getProduct(for action: ProductDetailIActionType)
    
    func saveChanges()
}

// Protocol defining the output method for Product Detail Interactor
public protocol ProductDetailInteractorOutput: AnyObject {
    func reload(product: Product)
    
    func productFetchingError(title: String)
    
    func outputToggleIsFavorite(product: Product)
    
    func outputToggleIsBucketInside(product: Product)
    
    func outputProductWithoutRefetching(product: Product)
}

public enum ProductDetailIActionType {
    case toggleIsFavorite, toggleIsBucketInside, setupButtons
}

final class ProductDetailInteractor: ProductDetailInteractorInput, ProductDifferencable, ProductPredicateGenerator {
    
    private let productDataService: ProductDataServiceProtocol
    public weak var output: ProductDetailInteractorOutput?
    
    private var product: Product
    
    init(productDataService: ProductDataServiceProtocol, product: Product) {
        self.productDataService = productDataService
        self.product = product
    }
    
    public func updateCache(with product: Product) {
        //productDataService.updateProduct(stategy: .fromCache, product: product)
    }
    
    public func saveChanges() {
        productDataService.updateProduct(strategy: .fromBD, product: product)
    }
    
    func getProduct(for action: ProductDetailIActionType) {
        switch action {
        case .toggleIsFavorite:
            output?.outputToggleIsFavorite(product: product)
            output?.outputProductWithoutRefetching(product: product)
        case .toggleIsBucketInside:
            output?.outputToggleIsBucketInside(product: product)
            output?.outputProductWithoutRefetching(product: product)
        case .setupButtons:
            output?.outputProductWithoutRefetching(product: product)
        }
    }
    
    public func fetchProduct() {
        
        let strategy = DataStrategy.fromCache
        switch strategy {
        case .fromCache:
            let predicate = generate(dataType: .cache, queryType: .detail)
            let productsResult = productDataService.fetchProducts(strategy: .fromCache,
                                                                  predicate: predicate)
            
            if case let .success(productsFromCashe) = productsResult {
                guard let product = productsFromCashe.first else {
                    fallthrough
                }
                
                self.product = product
            }
        case .fromBD:
            let predicate = generate(dataType: .bd, queryType: .detail)
            let productsResult = productDataService.fetchProducts(strategy: .fromBD,
                                                                  predicate: predicate)
            
            if case let .success(productsFromBD) = productsResult {
                guard let product = productsFromBD.first else {
                    fallthrough
                }
                
                self.product = product
            }
            
        case .fromJson:
            let predicate = generate(dataType: .json, queryType: .detail)
            let productsResult = productDataService.fetchProducts(strategy: .fromJson,
                                                                  predicate: predicate)
            
            if case let .success(productsFromLocalFile) = productsResult {
                guard let product = productsFromLocalFile.first else {
                    return
                }
                
                self.product = product
            }
        }
        output?.reload(product: product)
    }
}
