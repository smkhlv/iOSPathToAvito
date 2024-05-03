import Foundation

protocol BucketListPresenterProtocol: AnyObject { }

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
        coordinator.showDetail(product: product, subject: interactor.subjectObject())
    }
    
    func change(product: [UUID: Product]) {
        interactor.change(product: product)
    }
}
