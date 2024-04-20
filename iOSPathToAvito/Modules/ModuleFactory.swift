import UIKit

struct ModuleFactory {
    
    static func buildBucketList(coordinator: BucketListCoordinatorProtocol) -> UIViewController {
        let interactor = BucketListInteractor()
        let presenter = BucketListPresenter(coordinator: coordinator,
                                            interactor: interactor)
        let view = BucketListViewController(presenter: presenter)
        
        interactor.output = presenter
        return view
    }
}
