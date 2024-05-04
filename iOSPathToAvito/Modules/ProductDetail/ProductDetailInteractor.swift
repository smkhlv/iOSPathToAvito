import Foundation

// Protocol defining the input methods for Product Detail Interactor
public protocol ProductDetailInteractorInput {
    
    /// Updates the current product with the provided product
    /// - Parameter product: The product to be updated
    func updateProduct(_ product: Product)
    
    /// Shows the current product
    func showProduct()
    
    /// Toggles the favorite status of the current product
    func changeIsFavorite()
    
    /// Toggles the bucket inside status of the current product
    func changeIsBucketInside()
    
    func removeSubjectFromObservers()
}

// Protocol defining the output method for Product Detail Interactor
public protocol ProductDetailInteractorOutput: AnyObject {
    func showProduct(_ product: Product)
}

final class ProductDetailInteractor: ProductDetailInteractorInput, ObserverInteractor {
    var id: String = UUID().uuidString

    var products: [UUID : Product] = [:]
    
    public weak var subject: SubjectInteractorProtocol?
    public weak var output: ObserverInteractorOutput?
    public weak var outputToPresenter: ProductDetailInteractorOutput?
    
    private var currentProduct: Product
    
    public func showProduct() {
        outputToPresenter?.showProduct(currentProduct)
    }
    
    public func updateProduct(_ product: Product) {
        currentProduct = product
    }
    
    public func changeIsFavorite() {
        currentProduct.isFavorite = !currentProduct.isFavorite
        subject?.updateProduct(currentProduct)
    }
    
    public func changeIsBucketInside() {
        currentProduct.isBucketInside = !currentProduct.isBucketInside
        subject?.updateProduct(currentProduct)
    }
    
    public func removeSubjectFromObservers() {
        subject?.observers.removeAll(where: { $0 is ProductDetailInteractor })
    }
    
    init(currentProduct: Product) {
        self.currentProduct = currentProduct
    }
}

// MARK: - ObserverInteractorOutput

extension ProductDetailInteractor: ObserverInteractorOutput {
    func update(list: [UUID : Product]) { }
}
