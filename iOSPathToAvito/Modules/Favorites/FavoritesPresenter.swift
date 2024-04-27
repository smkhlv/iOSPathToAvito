import Foundation

protocol FavoritesPresenterProtocol: AnyObject {
    func updateProductList()
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
    
    func updateProductList() {
        interactor.updateProductList()
    }
}

extension FavoritesPresenter: FavoritesInteractorOutput {
    func productFetchingError(title: String) {
        print(title)
    }
    
    func products(list: [UUID: Product]) {
        view?.updateProductListTable(products: list)
    }
}

extension FavoritesPresenter: ProductCellDelegate {
    
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
