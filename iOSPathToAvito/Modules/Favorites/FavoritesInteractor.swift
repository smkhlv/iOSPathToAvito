import Foundation
import UIKit

/// Defining the input methods for the Favorites Interactor
protocol FavoritesInteractorInput: AnyObject {
    
    func saveChanges()
    
    func fetchProducts()
}

protocol FavoritesInteractorOutput: AnyObject {
    
    /// Method to notify about product fetching error
    func productFetchingError(title: String)
    
    func append(products: [Product])
    
    func reload(products: [Product])
    
    func delete(products: [Product])
}

final class FavoritesInteractor: FavoritesInteractorInput {

    public weak var output: FavoritesInteractorOutput?
    private let repository: RepositoryProtocol
    
    private var products: [Product] = []
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    public func saveChanges() {
        repository.save()
    }
    
    func fetchProducts() {
        let predicate = NSPredicate.equalPredicate(key: "_isFavorite", value: 1)
        
        switch repository.fetchProducts(predicate: predicate, 
                                        fetchStrategy: .fromBD) {
        case .success(let products):
            
            if self.products.isEmpty {
                output?.append(products: products)
                self.products = products
                return
            }
            if self.products.count != products.count {
                if self.products.count > products.count {
                    output?.delete(products: self.products.difference(from: products))
                } else {
                    output?.append(products: self.products.difference(from: products))
                }
                self.products = products
                return
            }
            if self.products.hasChanges(with: products) {
                output?.reload(products: products)
                self.products = products
                return
            }

            self.products = products
        case .failure(let error):
            output?.productFetchingError(title: error.localizedDescription)
        }
    }
}
