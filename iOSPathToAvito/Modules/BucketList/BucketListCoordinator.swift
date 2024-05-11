import UIKit

// Protocol defining the methods a bucket list coordinator should implement
protocol BucketListCoordinatorProtocol: AnyObject {
    
    /// Method to present the detail view for a product
    /// - Parameters:
    ///   - product: The product to show detail for
    func showDetail(product: Product)
}

final class BucketListCoordinator: BucketListCoordinatorProtocol, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private var repository: RepositoryProtocol?
    
    var type: CoordinatorType { .bucket }
    
    func start(view: UIViewController? = nil) {
        guard let view = view else { return }
        navigationController.pushViewController(view, animated: true)
    }
    
    func showDetail(product: Product) {
        guard let repository = repository else { return }
        let detail = ModuleFactory.buildProductDetail(product: product,
                                                      repository: repository)
        navigationController.pushViewController(detail, animated: true)
    }
    
    required init(_ navigationController: UINavigationController,
                  repository: RepositoryProtocol?) {
        self.repository = repository
        self.navigationController = navigationController
    }
}

// MARK: - CoordinatorFinishDelegate

extension BucketListCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
