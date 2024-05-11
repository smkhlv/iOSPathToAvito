import Foundation

// Protocol defining the interface for the BucketListPresenter
protocol BucketListPresenterProtocol: AnyObject {
    func fetchProducts()
}

// Presenter responsible for coordinating actions for the bucket list
final class BucketListPresenter: BucketListPresenterProtocol {
    
    public weak var view: BucketListViewControllerProtocol?
    private let coordinator: BucketListCoordinatorProtocol
    private let interactor: BucketListInteractorInput
    
    init(
        coordinator: BucketListCoordinatorProtocol,
        interactor: BucketListInteractorInput
    ) {
        self.coordinator = coordinator
        self.interactor = interactor
    }
    
    public func fetchProducts() {
        interactor.fetchProducts()
    }
}

// MARK: - BucketListInteractorOutput

extension BucketListPresenter: BucketListInteractorOutput {
    func productFetchingError(title: String) {
        print(title)
    }
    
    func append(products: [Product]) {
        view?.append(products: products)
    }
    
    func reload(products: [Product]) {
        view?.reload(products: products)
    }
    
    func delete(products: [Product]) {
        view?.delete(products: products)
    }
}

// MARK: - ProductCellDelegate

extension BucketListPresenter: ProductCellDelegate {
    
    func toggleIsFavorite(product: Product) {
        product.isFavorite = !product.isFavorite
        interactor.saveChanges()
        interactor.fetchProducts() 
    }
    
    func toggleIsBucketInside(product: Product) {
        product.isBucketInside = !product.isBucketInside
        interactor.saveChanges()
        interactor.fetchProducts()
    }

    func showDetail(product: Product) {
        coordinator.showDetail(product: product)
    }
}
