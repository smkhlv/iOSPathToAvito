import UIKit

// Protocol defining the methods a bucket list coordinator should implement
protocol BucketListCoordinatorProtocol: AnyObject {
    
    /// Method to present the detail view for a product
    /// - Parameters:
    ///   - product: The product to show detail for
    ///   - subject: The subject interactor for observing changes
    func showDetail(product: Product, subject: SubjectInteractorProtocol?)
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
    
    func showDetail(product: Product, subject: SubjectInteractorProtocol?) {
        let detail = ModuleFactory.buildProductDetail(product: product,
                                                      subject: subject)
        navigationController.pushViewController(detail, animated: true)
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - CoordinatorFinishDelegate

extension BucketListCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
