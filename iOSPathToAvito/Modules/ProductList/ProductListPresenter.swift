import Foundation

// Protocol defining the interface for the Product List Presenter
protocol ProductListPresenterProtocol: AnyObject {
    
    // Fetches the products to be displayed in the product list
    func fetchProducts()
}

final class ProductListPresenter: ProductListPresenterProtocol {
    
    public weak var view: ProductListViewControllerProtocol?
    public var subject: SubjectInteractorProtocol?
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

// MARK: - ProductListInteractorOutput

extension ProductListPresenter: ProductListInteractorOutput {
    func productFetchingError(title: String) {
        debugPrint(title)
    }
    
    func products(list: [UUID: Product]) {
        view?.updateProductListTable(products: list)
    }
}

// MARK: - ProductCellDelegate

extension ProductListPresenter: ProductCellDelegate {
    func showDetail(product: Product) {
        coordinator.showDetail(product: product, subject: subject)
    }
    
    func change(product: [UUID: Product]) {
        interactor.change(product: product)
    }
}
