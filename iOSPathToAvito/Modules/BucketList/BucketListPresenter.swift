protocol BucketListPresenterProtocol: AnyObject {
    func viewDidLoad(view: BucketListViewControllerProtocol)
}

final class BucketListPresenter: BucketListPresenterProtocol {
    
    private weak var view: BucketListViewControllerProtocol?
    private let coordinator: BucketListCoordinatorProtocol
    private let interactor: BucketListInteractorInput
    
    init(
        view: BucketListViewControllerProtocol? = nil,
        coordinator: BucketListCoordinatorProtocol,
        interactor: BucketListInteractorInput
    ) {
        self.view = view
        self.coordinator = coordinator
        self.interactor = interactor
    }
    
    func viewDidLoad(view: any BucketListViewControllerProtocol) { }
}

extension BucketListPresenter: BucketListInteractorOutput {
    
}
