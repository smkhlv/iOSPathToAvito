import UIKit

/// Protocol defining the behavior of a Favorites Coordinator
protocol FavoritesCoordinatorProtocol: AnyObject {
    
    /// Method to show product detail
    ///
    /// - Parameters:
    ///   - product: The product to show detail for
    func showDetail(product: Product)
}

final class FavoritesCoordinator: FavoritesCoordinatorProtocol, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private var repository: RepositoryProtocol?
    
    var type: CoordinatorType { .favorites }
    
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

extension FavoritesCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
