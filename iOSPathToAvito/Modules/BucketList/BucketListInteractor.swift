import Foundation
import UIKit

// Protocol defining the input methods for the bucket list interactor
protocol BucketListInteractorInput: AnyObject {
    
    func saveChanges()
    
    func fetchProducts()
}

// Protocol defining the output methods for the bucket list interactor
protocol BucketListInteractorOutput: AnyObject {
    func productFetchingError(title: String)
    func append(products: [Product])
    
    func reload(products: [Product])
    
    func delete(products: [Product])
}

final class BucketListInteractor: BucketListInteractorInput {

    public weak var output: BucketListInteractorOutput?
    private let repository: RepositoryProtocol
    
    private var products: [Product] = []
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    public func saveChanges() {
        repository.save()
    }
    
    func fetchProducts() {
        let predicate = NSPredicate.equalPredicate(key: "_isBucketInside", value: 1)
        
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
