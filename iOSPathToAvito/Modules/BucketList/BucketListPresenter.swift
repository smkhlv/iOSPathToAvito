import Foundation

// Protocol defining the interface for the BucketListPresenter
protocol BucketListPresenterProtocol: AnyObject { }


// Presenter responsible for coordinating actions for the bucket list
final class BucketListPresenter: BucketListPresenterProtocol {
    
    public weak var view: BucketListViewControllerProtocol?
    public weak var subject: SubjectInteractorProtocol?
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

// MARK: - BucketListInteractorOutput

extension BucketListPresenter: BucketListInteractorOutput {
    func productFetchingError(title: String) {
        print(title)
    }
    
    func products(list: [UUID: Product]) {
        view?.updateProductListTable(products: list)
    }
}

// MARK: - ProductCellDelegate

extension BucketListPresenter: ProductCellDelegate {
    func showDetail(product: Product) {
        coordinator.showDetail(product: product, subject: subject)
    }
    
    func change(product: [UUID: Product]) {
        interactor.change(product: product)
    }
}
