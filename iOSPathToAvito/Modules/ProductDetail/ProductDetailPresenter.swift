import Foundation

// Protocol for Product Detail Presenter interactions
public protocol ProductDetailPresenterProtocol: AnyObject {
    
    /// Displays the current product
    func showProduct()
    
    func toggleIsFavorite()
    
    func toggleIsBucketInside()
    
    var stateOfFavorite: StateButton { get }
    
    var stateOfBucket: StateButton { get }
    
    func setupStateButtons()
    
}

public final class ProductDetailPresenter: ProductDetailPresenterProtocol {
    public weak var view: ProductDetailViewControllerProtocol?
    
    private let interactor: ProductDetailInteractorInput
    
    public var stateOfFavorite: StateButton = .unpressed
    public var stateOfBucket: StateButton = .unpressed

    init(interactor: ProductDetailInteractorInput) {
        self.interactor = interactor
    }
    
    public func toggleIsFavorite() {
        interactor.getProduct(for: .toggleIsFavorite)
    }
    
    public func toggleIsBucketInside() {
        interactor.getProduct(for: .toggleIsBucketInside)
    }
    
    public func showProduct() {
        interactor.fetchProduct()
    }
    
    public func setupStateButtons() {
        interactor.getProduct(for: .setupButtons)
    }
}

// MARK: - ProductDetailInteractorOutput
//
extension ProductDetailPresenter: ProductDetailInteractorOutput {
    public func outputProductWithoutRefetching(product: Product) {
        stateOfBucket = product.isBucketInside ? .pressed : .unpressed
        stateOfFavorite = product.isFavorite ? .pressed : .unpressed
    }
    
    public func outputToggleIsFavorite(product: Product) {
        product.isFavorite = !product.isFavorite
        interactor.saveChanges()
    }
    
    public func outputToggleIsBucketInside(product: Product) {
        product.isBucketInside = !product.isBucketInside
        interactor.saveChanges()
    }
    
   
    public func reload(product: Product) {
        view?.updateDetail(product)
    }
    
    public func productFetchingError(title: String) {
        print(title)
    }
}

