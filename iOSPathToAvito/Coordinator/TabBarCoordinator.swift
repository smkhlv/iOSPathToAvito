import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}

final class TabCoordinator: NSObject, Coordinator, TabCoordinatorProtocol {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
        
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController

    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
    }

    func start(view: UIViewController? = nil) {
        let pages: [TabBarPage] = [.productList, .favorites, .bucketList]
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    deinit {
        print("TabCoordinator deinit")
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.productList.pageIndex
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = .darkGray
        
        navigationController.viewControllers = [tabBarController]
    }
      
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)

        navController.tabBarItem = UITabBarItem.init(title: page.title,
                                                     image: page.image,
                                                     selectedImage: page.selectedImage)
        navController.tabBarItem.tag = page.pageIndex

        switch page {
        case .productList:
            let productListVC = ProductListViewController()
            navController.pushViewController(productListVC, animated: true)
        case .bucketList:
//            let bucketListVC = ModuleFactory.build(with: .bucketList)
//            navController.pushViewController(bucketListVC, animated: true)
            
            let bucketListCoordinator = BucketListCoordinator.init(UINavigationController())
            let build = ModuleFactory.buildBucketList(coordinator: bucketListCoordinator)
            bucketListCoordinator.finishDelegate = self
            bucketListCoordinator.start(view: build)
            childCoordinators.append(bucketListCoordinator)
        case .favorites:
            let favoritesVC = FavoritesViewController()
            navController.pushViewController(favoritesVC, animated: true)
        }
        
        return navController
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageIndex
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageIndex
    }
}

extension TabCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
    }
}
