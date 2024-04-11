import UIKit

public final class MainTabBarController: UITabBarController {

    init(_ modules: ModuleName...) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = modules.map { ModuleFactory.make(with: $0) }
        tabBar.barTintColor = .darkGray
        tabBar.isTranslucent = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
