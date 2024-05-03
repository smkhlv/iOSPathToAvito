import Foundation
public protocol ProductDetailInteractorInput {
    func updateProduct(_ product: Product)
    func showProduct() 
    
    func changeIsFavorite()
    
    func changeIsBucketInside()
}

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
    
    init(currentProduct: Product) {
        self.currentProduct = currentProduct
    }
}

extension ProductDetailInteractor: ObserverInteractorOutput {
    func update(list: [UUID : Product]) { }
}
