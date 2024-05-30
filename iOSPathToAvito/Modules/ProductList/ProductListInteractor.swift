import Foundation
import UIKit

// Protocol defining the input methods for the Product List Interactor
protocol ProductListInteractorInput: AnyObject {
    
    func saveChanges()
    
    func fetchProducts()
    
    //func updateCache(with product: Product)
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

final class ProductListInteractor: ProductListInteractorInput, ProductDifferencable, ProductPredicateGenerator {
    
    public weak var output: ProductListInteractorOutput?
    private var productDataService: ProductDataServiceProtocol
    
    private var products = [Product]()
    
    init(productDataService: ProductDataServiceProtocol) {
        self.productDataService = productDataService
    }
    
    private func compareAndUpdate(with products: [Product]) {

        if self.products.isEmpty {
            output?.append(products: products)
        } else {
            output?.reload(products: products)
        }
        
        self.products = products
        productDataService.createProducts(strategy: .fromCache, products: products)
    }
    
    func saveChanges() {
        guard let product = products.first else {
            return
        }
        productDataService.updateProduct(strategy: .fromBD, product: product)
    }
    
    private func fetchFromCache() -> Bool {
        let predicate = generate(dataType: .cache, queryType: .productList)
        let productsResult = productDataService.fetchProducts(strategy: .fromCache,
                                                              predicate: predicate)
        
        if case let .success(productsFromCashe) = productsResult {
            if productsFromCashe.isEmpty {
                return false
            } else {
                compareAndUpdate(with: productsFromCashe)
                return true
            }
        }
        return false
    }
    
    private func fetchFromBD() -> Bool {
        let predicate = generate(dataType: .bd, queryType: .productList)
        let productsResult = productDataService.fetchProducts(strategy: .fromBD,
                                                              predicate: predicate)
        
        if case let .success(productsFromCashe) = productsResult {
            if productsFromCashe.isEmpty {
                return false
            } else {
                compareAndUpdate(with: productsFromCashe)
                return true
            }
        }
        return false
    }
    
    private func fetchFromJson() -> Bool {
        let predicate = generate(dataType: .json, queryType: .productList)
        let productsResult = productDataService.fetchProducts(strategy: .fromJson,
                                                              predicate: predicate)
        
        if case let .success(productsFromCashe) = productsResult {
            if productsFromCashe.isEmpty {
                return false
            } else {
                compareAndUpdate(with: productsFromCashe)
                return true
            }
        }
        return false
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
