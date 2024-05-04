import Foundation

// Protocol for Product Detail Presenter interactions
public protocol ProductDetailPresenterProtocol: AnyObject {
    
    /// Updates the product in the presenter
    /// - Parameter product: The product to update
    func updateProduct(_ product: Product)
    
    /// Displays the current product
    func showProduct()
    
    /// Changes the favorite status of the current product
    func changeIsFavorite()
    
    /// Changes the bucket inside status of the current product
    func changeIsBucketInside()
    
    func removeSubjectFromObservers()
}

public final class ProductDetailPresenter: ProductDetailPresenterProtocol {
    public weak var view: ProductDetailViewControllerProtocol?
    
    private let interactor: ProductDetailInteractorInput
    
    init(interactor: ProductDetailInteractorInput) {
        self.interactor = interactor
    }
    
    public func updateProduct(_ product: Product) {
        interactor.updateProduct(product)
    }
    
    public func showProduct() {
        interactor.showProduct()
    }
    
    public func changeIsFavorite() {
        interactor.changeIsFavorite()
    }
    
    public func changeIsBucketInside() {
        interactor.changeIsBucketInside()
    }
    
    public func removeSubjectFromObservers() {
        interactor.removeSubjectFromObservers()
    }
}

// MARK: - ProductDetailInteractorOutput

extension ProductDetailPresenter: ProductDetailInteractorOutput {
    public func showProduct(_ product: Product) {
        view?.updateDetail(product)
    }
}

