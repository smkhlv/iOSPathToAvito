import UIKit

// Enum representing the different pages of the tab bar
public enum TabBarPage {
    case bucketList, productList, favorites
    
    // Initialize TabBarPage based on index
    init?(index: Int) {
        switch index {
        case 0:
            self = .bucketList
        case 1:
            self = .productList
        case 2:
            self = .favorites
        default:
            return nil
        }
    }
    
    // Title of the tab page
    var title: String {
        switch self {
        case .productList:
            return "Список товаров"
        case .favorites:
            return "Избранное"
        case .bucketList:
            return "Корзина"
        }
    }

    // Index of the tab page
    var pageIndex: Int {
        switch self {
        case .productList:
            return 0
        case .favorites:
            return 1
        case .bucketList:
            return 2
        }
    }
    
    // Image for the tab page
    var image: UIImage? {
        switch self {
        case .productList:
            return UIImage(systemName: "guitars")
        case .favorites:
            return UIImage(systemName: "star")
        case .bucketList:
            return UIImage(systemName: "basket")
        }
    }
    
    // Selected image for the tab page
    var selectedImage: UIImage? {
        switch self {
        case .productList:
            return UIImage(systemName: "guitars.fill")
        case .favorites:
            return UIImage(systemName: "star.fill")
        case .bucketList:
            return UIImage(systemName: "basket.fill")
        }
    }
}
