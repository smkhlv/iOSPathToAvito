import Foundation

// Protocol defining the interface for FavoritesPresenter interactions
protocol FavoritesPresenterProtocol: AnyObject { }

final class FavoritesPresenter: FavoritesPresenterProtocol {
    
    public weak var view: FavoritesViewControllerProtocol?
    public weak var subject: SubjectInteractorProtocol?
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

// MARK: - FavoritesInteractorOutput

extension FavoritesPresenter: FavoritesInteractorOutput {
    func productFetchingError(title: String) {
        print(title)
    }
    
    func products(list: [UUID : Product]) {
        view?.updateProductListTable(products: list)
    }
}

// MARK: - ProductCellDelegate

extension FavoritesPresenter: ProductCellDelegate {
    
    func showDetail(product: Product) {
        coordinator.showDetail(product: product, subject: subject)
    }
    
    func change(product: [UUID: Product]) {
        interactor.change(product: product)
    }
}
