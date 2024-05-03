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
        interactor.setupProducts()
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
        coordinator.showDetail(product: product, subject: interactor.subjectObject())
    }
    
    func change(product: [UUID: Product]) {
        interactor.change(product: product)
    }
}
