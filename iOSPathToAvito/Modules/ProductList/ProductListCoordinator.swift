import UIKit

// Protocol defining the methods for coordinating product list interactions
protocol ProductListCoordinatorProtocol: AnyObject {
    
    /// Shows the product detail view for the specified product
    /// - Parameters:
    ///   - product: The product to display details for
    func showDetail(product: Product)
}

final class ProductListCoordinator: ProductListCoordinatorProtocol, Coordinator {    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private var repository: RepositoryProtocol?
    
    var type: CoordinatorType { .productList }
    
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

extension ProductListCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
