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

    var type: CoordinatorType { .productList }
    
    func start(view: UIViewController? = nil) {
        guard let view = view else { return }
        navigationController.pushViewController(view, animated: true)
    }
    
    func showDetail(product: Product) {
        let detail = ModuleFactory.buildProductDetail(product: product,
                                                      dataService: DependencyContainer.shared.makeProductDataService())
        navigationController.pushViewController(detail, animated: true)
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - CoordinatorFinishDelegate

extension ProductListCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
