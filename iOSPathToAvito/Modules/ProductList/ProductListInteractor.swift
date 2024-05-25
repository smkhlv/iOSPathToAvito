import Foundation
import UIKit

// Protocol defining the input methods for the Product List Interactor
protocol ProductListInteractorInput: AnyObject {
    
    func saveChanges()
    
    func fetchProducts()
}

// Protocol defining the output methods for the Product List Interactor
public protocol ProductListInteractorOutput: AnyObject {
    /// Notifies about an error occurred during product fetching
    /// - Parameter title: The title of the error
    func productFetchingError(title: String)
    
    func append(products: [Product])
    
    func reload(products: [Product])
    
    func delete(products: [Product])
}

final class ProductListInteractor: ProductListInteractorInput {
    
    public weak var output: ProductListInteractorOutput?
    private let repository: RepositoryProtocol
    
    private var products: [Product] = []

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    public func saveChanges() {
        repository.save()
    }
    
    func fetchProducts() {
        switch repository.fetchProducts(predicate: nil, 
                                        fetchStrategy: .fromBDAndJson) {
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

