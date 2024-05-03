import Foundation

protocol FavoritesPresenterProtocol: AnyObject { }

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
}

extension FavoritesPresenter: FavoritesInteractorOutput {
    func productFetchingError(title: String) {
        print(title)
    }
    
    func products(list: [UUID : Product]) {
        view?.updateProductListTable(products: list)
    }
}

extension FavoritesPresenter: ProductCellDelegate {
    
    func showDetail(product: Product) {
        coordinator.showDetail(product: product, subject: interactor.subjectObject())
    }
    
    func change(product: [UUID: Product]) {
        interactor.change(product: product)
    }
}
