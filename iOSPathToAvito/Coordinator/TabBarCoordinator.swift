import UIKit

// Protocol defining the coordinator responsible for managing tab-based navigation
protocol TabCoordinatorProtocol: Coordinator {
    // Tab bar controller associated with the coordinator
    var tabBarController: UITabBarController { get set }
    
    // Method to select a specific tab page
    func selectPage(_ page: TabBarPage)
    
    // Method to set the selected index of the tab bar
    func setSelectedIndex(_ index: Int)
    
    // Method to get the currently selected tab page
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
        
        let loader: LoaderProtocol = Loader()
        let dataManager: DataServiceProtocol = DataRequestService(coreDataAssembler: CoreDataAssembler())
        let subjectInteractor: SubjectInteractorProtocol = SubjectInteractor()
        
        let controllers: [UINavigationController] = pages.map({ getTabController($0,
                                                                                 loader: loader,
                                                                                 dataManager: dataManager,
                                                                                 subject: subjectInteractor)
        })
        
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
    
    private func getTabController(_ page: TabBarPage,
                                  loader: LoaderProtocol,
                                  dataManager: DataServiceProtocol,
                                  subject: SubjectInteractorProtocol) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        
        navController.tabBarItem = UITabBarItem.init(title: page.title,
                                                     image: page.image,
                                                     selectedImage: page.selectedImage)
        navController.tabBarItem.tag = page.pageIndex
        
        switch page {
        case .productList:
            let productListCoordinator = ProductListCoordinator(navController)
            let build = ModuleFactory.buildProductList(coordinator: productListCoordinator,
                                                       loader: loader,
                                                       dataManager: dataManager,
                                                       subject: subject)
            
            productListCoordinator.finishDelegate = self
            productListCoordinator.start(view: build)
            childCoordinators.append(productListCoordinator)
        case .bucketList:
            let bucketListCoordinator = BucketListCoordinator(navController)
            let build = ModuleFactory.buildBucketList(coordinator: bucketListCoordinator,
                                                      loader: loader,
                                                      dataManager: dataManager,
                                                      subject: subject)
            bucketListCoordinator.finishDelegate = self
            bucketListCoordinator.start(view: build)
            childCoordinators.append(bucketListCoordinator)
        case .favorites:
            let favoritesCoordinator = FavoritesCoordinator(navController)
            let build = ModuleFactory.buildFavorites(coordinator: favoritesCoordinator,
                                                     loader: loader,
                                                     dataManager: dataManager,
                                                     subject: subject)
            favoritesCoordinator.finishDelegate = self
            favoritesCoordinator.start(view: build)
            childCoordinators.append(favoritesCoordinator)
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

// MARK: - CoordinatorFinishDelegate

extension TabCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) { }
}
