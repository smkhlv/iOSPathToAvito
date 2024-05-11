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

final class ProductDetailInteractor: ProductDetailInteractorInput {
    
    private let repository: RepositoryProtocol
    public weak var output: ProductDetailInteractorOutput?
    
    private var product: Product
    
    init(repository: RepositoryProtocol, product: Product) {
        self.repository = repository
        self.product = product
    }
    
    public func saveChanges() {
        repository.save()
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
        guard let id = product.id else { return }
        let predicate = NSPredicate.equalPredicate(key: "id", value: id)
        
        switch repository.fetchProducts(predicate: predicate,
                                        fetchStrategy: .fromBD) {
        case .success(let products):
            if let product = products.first {
                self.product = product
            }
            output?.reload(product: product)
        case .failure(let error):
            output?.productFetchingError(title: error.localizedDescription)
        }
    }
}
