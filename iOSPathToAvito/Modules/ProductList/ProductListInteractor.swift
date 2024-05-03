import Foundation
import UIKit

protocol ProductListInteractorInput: AnyObject {
    func setupProducts()
    
    func change(product: [UUID: Product])
    
    func subjectObject() -> SubjectInteractorProtocol?
}

public protocol ProductListInteractorOutput: AnyObject {
    func productFetchingError(title: String)
    
    func products(list: [UUID: Product])
}

final class ProductListInteractor: ProductListInteractorInput,
                                   ObserverInteractor {
    
    var id: String = UUID().uuidString
    
    public weak var output: ObserverInteractorOutput?
    public weak var outputToPresenter: ProductListInteractorOutput?
    private let loader: LoaderProtocol
    private let dataManager: DS
    public var subject: SubjectInteractorProtocol?
    
    var products: [UUID: Product] = [:]
    
    init(loader: LoaderProtocol, dataManager: DS) {
        self.loader = loader
        self.dataManager = dataManager
    }
    
    public func subjectObject() -> SubjectInteractorProtocol? {
        return subject
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

extension ProductListInteractor: ObserverInteractorOutput {
    func update(list: [UUID : Product]) {
        outputToPresenter?.products(list: list)
    }
}
