import UIKit

protocol BucketListCoordinatorProtocol: AnyObject {
    func showDetail(product: Product)
}

final class BucketListCoordinator: BucketListCoordinatorProtocol, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .bucket }
    
    func start(view: UIViewController? = nil) {
        guard let view = view else { return }
        navigationController.pushViewController(view, animated: true)
    }
    
    func showDetail(product: Product) {
        let detail = ModuleFactory.buildProductDetail(product: product)
        navigationController.pushViewController(detail, animated: true)
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension BucketListCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
