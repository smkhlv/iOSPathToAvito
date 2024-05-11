import UIKit

// Protocol defining a coordinator that can manage multiple types of flows
protocol AnyCoordinator: TabCoordinatorProtocol,
                            AppCoordinatorProtocol,
                         BucketListCoordinatorProtocol { }

// Protocol defining common properties and methods for a coordinator
protocol Coordinator: AnyObject {
    // Delegate to notify when the coordinator finishes its flow
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    // Navigation controller associated with the coordinator
    var navigationController: UINavigationController { get set }
    
    // Array to keep track of child coordinators
    var childCoordinators: [Coordinator] { get set }
    
    // Type of the coordinator's flow
    var type: CoordinatorType { get }
    
    // Method to start the flow
    func start(view: UIViewController?)
    
    // Method to finish the flow and clean up resources
    func finish()
    
    init(_ navigationController: UINavigationController,
                  repository: RepositoryProtocol?)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

// MARK: - CoordinatorOutput

// Delegate protocol helping parent Coordinator know when its child is ready to be finished.
protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

// MARK: - CoordinatorType

// Using this structure we can define what type of flow we can use in-app.
enum CoordinatorType {
    case app, tab, bucket, favorites, productList
}
