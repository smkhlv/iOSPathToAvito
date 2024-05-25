import Foundation

// Protocol defining the interface for the Product List Presenter
protocol ProductListPresenterProtocol: AnyObject {
    
    // Fetches the products to be displayed in the product list
    func fetchProducts()
}

final class ProductListPresenter: ProductListPresenterProtocol {
    
    public weak var view: ProductListViewControllerProtocol?
    private let coordinator: ProductListCoordinatorProtocol
    private let interactor: ProductListInteractorInput
    
    init(
        coordinator: ProductListCoordinatorProtocol,
        interactor: ProductListInteractorInput
    ) {
        self.coordinator = coordinator
        self.interactor = interactor
    }
    
    func fetchProducts() {
        interactor.fetchProducts()
    }
}

// MARK: - ProductListInteractorOutput

extension ProductListPresenter: ProductListInteractorOutput {
    func append(products: [Product]) {
        view?.append(products: products)
    }
    
    func reload(products: [Product]) {
        view?.reload(products: products)
    }
    
    func delete(products: [Product]) {
        view?.delete(products: products)
    }
    
    func productFetchingError(title: String) {
        debugPrint(title)
    }
}

// MARK: - ProductCellDelegate

extension ProductListPresenter: ProductCellDelegate {
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
