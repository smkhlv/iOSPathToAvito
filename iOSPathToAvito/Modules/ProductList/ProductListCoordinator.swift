import UIKit

protocol ProductListCoordinatorProtocol: AnyObject {
    func showDetail(product: Product, subject: SubjectInteractorProtocol?)
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
    
    func showDetail(product: Product, subject: SubjectInteractorProtocol?) {
        let detail = ModuleFactory.buildProductDetail(product: product,
                                                      subject: subject)
        navigationController.pushViewController(detail, animated: true)
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension ProductListCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
