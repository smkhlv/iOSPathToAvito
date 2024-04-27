import Foundation

protocol ProductListPresenterProtocol: AnyObject {
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

extension ProductListPresenter: ProductListInteractorOutput {
    func productFetchingError(title: String) {
        debugPrint(title)
    }
    
    func products(list: [UUID: Product]) {
        view?.updateProductListTable(products: list)
    }
}

extension ProductListPresenter: ProductCellDelegate {
    func showDetail(product: Product) {
        coordinator.showDetail(product: product)
    }
    func toFavoritesWasClicked(productId: UUID?) {
        interactor.chageOfProductFavoriteState(id: productId)
    }
    
    func toBucketWasClicked(productId: UUID?) {
        interactor.changeOfProductBucketState(id: productId)
    }
}
