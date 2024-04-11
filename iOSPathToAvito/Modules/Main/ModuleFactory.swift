import UIKit

enum ModuleName {
    case home, detail
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .detail:
            return "Detail"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")
        case .detail:
            return UIImage(systemName: "book.pages")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill")
        case .detail:
            return UIImage(systemName: "book.pages.fill")
        }
    }
}

public struct ModuleFactory {
    
    static func make(with module: ModuleName) -> UIViewController {
        switch module {
        case .home:
            let homeVC = HomeViewController()
            homeVC.navigationItem.title = "Home"
            homeVC.view.backgroundColor = .blue
            homeVC.tabBarItem = UITabBarItem(
                title: module.title,
                image: module.image,
                selectedImage: module.selectedImage
            )
            return UINavigationController(rootViewController: homeVC)
        case .detail:
            let detailVC = DetailViewController()
            detailVC.navigationItem.title = "Detail"
            detailVC.view.backgroundColor = .red
            detailVC.tabBarItem = UITabBarItem(
                title: module.title,
                image: module.image,
                selectedImage: module.selectedImage
            )
            return UINavigationController(rootViewController: detailVC)
        }
    }
}
