import UIKit

// Protocol defining the coordinator responsible for managing the main app flow
protocol AppCoordinatorProtocol: Coordinator {
    // Method to show the main flow of the app
    func showMainFlow()
}

class AppCoordinator: AppCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()

    var type: CoordinatorType { .app }
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(view: UIViewController? = nil) {
        showMainFlow()
    }

    func showMainFlow() {
        let tabCoordinator = TabCoordinator.init(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

// MARK: - CoordinatorFinishDelegate

extension AppCoordinator: CoordinatorFinishDelegate {
    // Method called when a child coordinator finishes
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        // Handle any cleanup or additional logic here
    }
}
