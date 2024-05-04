import Foundation
import UIKit

// Protocol defining the input methods for the Product List Interactor
protocol ProductListInteractorInput: AnyObject {
    
    /// Sets up the products to be displayed in the product list
    func setupProducts()
    
    /// Changes the state of the product
    /// - Parameter product: The product with its updated state
    func change(product: [UUID: Product])
}

// Protocol defining the output methods for the Product List Interactor
public protocol ProductListInteractorOutput: AnyObject {
    /// Notifies about an error occurred during product fetching
    /// - Parameter title: The title of the error
    func productFetchingError(title: String)
    
    /// Passes the fetched products to the presenter
    /// - Parameter list: The dictionary of products with UUID as keys
    func products(list: [UUID: Product])
}

final class ProductListInteractor: ProductListInteractorInput,
                                   ObserverInteractor {
    
    var id: String = UUID().uuidString
    
    public weak var output: ObserverInteractorOutput?
    public weak var outputToPresenter: ProductListInteractorOutput?
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
    
    private func fetchFromDataBase() {
        guard products.isEmpty else {
            return
        }
        
        products = Dictionary(uniqueKeysWithValues: dataManager.fetch(Product.self).map { ($0.id ?? UUID(), $0) })
    }
    
    private func fetchFromJSON() {
        guard products.isEmpty else {
            return
        }
        
        guard let result = try? loader.fetchProducts() else {
            return
        }
        switch result {
        case .success(let success):
            let convertedFromDTO = success.compactMap {
                
                let product = dataManager.create(Product.self)!
                
                product.id = $0.id
                product.shopId = $0.shopId
                product.title = $0.title
                product.productDescription = $0.description
                product.price = $0.price
                product.isFavorite = false
                product.isBucketInside = false
                
                createProduct(product)
                return product
            }
            let convertedFromDTODic: [UUID: Product] = Dictionary(uniqueKeysWithValues: convertedFromDTO.map { ($0.id ?? UUID(), $0) })
            
            products = convertedFromDTODic
        case .failure(let failure):
            debugPrint(failure.localizedDescription)
            outputToPresenter?.productFetchingError(title: failure.localizedDescription)
        }
    }
    
    public func setupProducts() {
        
        guard products.isEmpty else {
            return
        }
        
        fetchFromDataBase()
        fetchFromJSON()
    }
}

// MARK: - ObserverInteractorOutput

extension ProductListInteractor: ObserverInteractorOutput {
    func update(list: [UUID : Product]) {
        outputToPresenter?.products(list: list)
    }
}
