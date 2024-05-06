import UIKit

/// Protocol defining the behavior of a Favorites Coordinator
protocol FavoritesCoordinatorProtocol: AnyObject {
    
    /// Method to show product detail
    ///
    /// - Parameters:
    ///   - product: The product to show detail for
    ///   - subject: The subject interactor protocol, if applicable
    func showDetail(product: Product, subject: SubjectInteractorProtocol?)
}

final class FavoritesCoordinator: FavoritesCoordinatorProtocol, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .favorites }
    
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

extension FavoritesCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
