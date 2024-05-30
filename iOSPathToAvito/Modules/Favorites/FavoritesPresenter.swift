import Foundation

// Protocol defining the interface for FavoritesPresenter interactions
protocol FavoritesPresenterProtocol: AnyObject { 
    func fetchProducts()
}

final class FavoritesPresenter: FavoritesPresenterProtocol {
    
    public weak var view: FavoritesViewControllerProtocol?
    private let coordinator: FavoritesCoordinatorProtocol
    private let interactor: FavoritesInteractorInput
    
    init(
        coordinator: FavoritesCoordinatorProtocol,
        interactor: FavoritesInteractorInput
    ) {
        self.coordinator = coordinator
        self.interactor = interactor
    }
    
    public func fetchProducts() {
        interactor.fetchProducts()
    }
}

// MARK: - FavoritesInteractorOutput

extension FavoritesPresenter: FavoritesInteractorOutput {
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
        print(title)
    }
}

// MARK: - ProductCellDelegate

extension FavoritesPresenter: ProductCellDelegate {
    
    func toggleIsFavorite(product: Product) {
        product.isFavorite = !product.isFavorite
        interactor.updateCache(with: product)
        view?.delete(products: [product])
    }
    
    func toggleIsBucketInside(product: Product) {
        product.isBucketInside = !product.isBucketInside
        interactor.updateCache(with: product)
        view?.reload(products: [product])
    }

    func showDetail(product: Product) {
        coordinator.showDetail(product: product)
    }
}
