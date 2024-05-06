import Foundation
import UIKit

/// Defining the input methods for the Favorites Interactor
protocol FavoritesInteractorInput: AnyObject {
    
    /// Method to change the product
    func change(product: [UUID: Product])
}

protocol FavoritesInteractorOutput: AnyObject {
    
    /// Method to notify about product fetching error
    func productFetchingError(title: String)
    
    func products(list: [UUID: Product])
}

final class FavoritesInteractor: FavoritesInteractorInput, ObserverInteractor {
    
    var id: String = UUID().uuidString
    
    public weak var output: ObserverInteractorOutput?
    public weak var outputToPresenter: FavoritesInteractorOutput?
    public weak var subject: SubjectInteractorProtocol?
    
    private let loader: LoaderProtocol
    private let dataManager: DataServiceProtocol
    
    var products: [UUID: Product] = [:]
    
    init(loader: LoaderProtocol, dataManager: DataServiceProtocol) {
        self.loader = loader
        self.dataManager = dataManager
    }
    
    public func change(product: [UUID: Product]) {
        if let product = product.first {
            products[product.key] = product.value
            subject?.updateProduct(product.value)
        }
    }
}

// MARK: - ObserverInteractorOutput

extension FavoritesInteractor: ObserverInteractorOutput {
    func update(list: [UUID : Product]) {
        if let product = list.first {
            products[product.key] = product.value
            products = products.filter { $0.value.isFavorite }
        }
        outputToPresenter?.products(list: products)
    }
}
