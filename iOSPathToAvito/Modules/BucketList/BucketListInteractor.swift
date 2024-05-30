import Foundation
import UIKit

// Protocol defining the input methods for the bucket list interactor
protocol BucketListInteractorInput: AnyObject {
    
    func saveChanges()
    
    func fetchProducts()
    
    func updateCache(with product: Product)
}

// Protocol defining the output methods for the bucket list interactor
protocol BucketListInteractorOutput: AnyObject {
    func productFetchingError(title: String)
    func append(products: [Product])
    
    func reload(products: [Product])
    
    func delete(products: [Product])
}

public enum ProductActionType {
    case append, delete, update
}

final class BucketListInteractor: BucketListInteractorInput, ProductPredicateGenerator {
    
    public weak var output: BucketListInteractorOutput?
    private let productDataService: ProductDataServiceProtocol
    
    private var products = [Product]()
    
    init(productDataService: ProductDataServiceProtocol) {
        self.productDataService = productDataService
    }
    
    public func updateCache(with product: Product) { }
    
    private func compareAndUpdate(with products: [Product]) {
        
        let resultComparing = productDataService.compare(oldArray: self.products, newArray: products)
        
        resultComparing.forEach {
            switch $0.key {
            case .append:
                if !$0.value.isEmpty {
                    output?.append(products: $0.value)
                }
            case .delete:
                if !$0.value.isEmpty {
                    output?.delete(products: $0.value)
                }
            case .update:
                if !$0.value.isEmpty {
                    output?.reload(products: $0.value)
                }
            }
        }
        if !resultComparing.contains(where: { $0.value.isEmpty }) {
            output?.reload(products: products)
        }
        
        self.products = products
    }
    
    func saveChanges() {
        guard let product = products.first else {
            return
        }
        productDataService.updateProduct(strategy: .fromBD, product: product)
    }
    
    private func fetchFromCache() -> Bool {
        let predicate = generate(dataType: .cache, queryType: .bucket)
        let productsResult = productDataService.fetchProducts(strategy: .fromCache,
                                                              predicate: predicate)
        
        if case let .success(productsFromCashe) = productsResult {
            compareAndUpdate(with: productsFromCashe)
            return true
        } else {
            return false
        }
    }
    
    private func fetchFromBD() -> Bool {
        let predicate = generate(dataType: .bd, queryType: .bucket)
        let productsResult = productDataService.fetchProducts(strategy: .fromBD,
                                                              predicate: predicate)
        
        if case let .success(productsFromBD) = productsResult {
            compareAndUpdate(with: productsFromBD)
            return true
        } else {
            return false
        }
    }
    
    private func fetchFromJson() -> Bool {
        let predicate = generate(dataType: .json, queryType: .bucket)
        let productsResult = productDataService.fetchProducts(strategy: .fromJson,
                                                              predicate: predicate)
        
        if case let .success(productsFromLocalFile) = productsResult {
            compareAndUpdate(with: productsFromLocalFile)
            return true
        } else {
            return false
        }
    }
    
    func fetchProducts() {
        
        if fetchFromCache() {
            return
        }
        if fetchFromBD() {
            return
        }
        if fetchFromJson() {
            return
        }
    }
}
