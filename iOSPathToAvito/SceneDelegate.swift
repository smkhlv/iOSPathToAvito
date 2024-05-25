import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let loader: LoaderProtocol = Loader()
        let dataManager: DataServiceProtocol = DataRequestService(coreDataAssembler: CoreDataAssembler())
        let repository: RepositoryProtocol = Repository(loader: loader,
                                                        dataRequestService: dataManager)
        
        appCoordinator = AppCoordinator.init(navigationController, repository: repository)
        appCoordinator?.start()
    }
}
