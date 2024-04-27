import Foundation

protocol BucketListPresenterProtocol: AnyObject {
    func updateProductList()
}

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
    
    func updateProductList() {
        interactor.updateProductList()
    }
}

extension BucketListPresenter: BucketListInteractorOutput {
    func productFetchingError(title: String) {
        print(title)
    }
    
    func products(list: [UUID: Product]) {
        view?.updateProductListTable(products: list)
    }
}

extension BucketListPresenter: ProductCellDelegate {
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
