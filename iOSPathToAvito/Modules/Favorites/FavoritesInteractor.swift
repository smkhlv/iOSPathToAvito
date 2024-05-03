import Foundation
import UIKit

protocol FavoritesInteractorInput: AnyObject {
    
    func change(product: [UUID: Product])
    
    func subjectObject() -> SubjectInteractorProtocol?
}

protocol FavoritesInteractorOutput: AnyObject {

    func productFetchingError(title: String)
    
    func products(list: [UUID: Product])
}

final class FavoritesInteractor: FavoritesInteractorInput, ObserverInteractor {
    
    var id: String = UUID().uuidString

    public weak var output: ObserverInteractorOutput?
    public weak var outputToPresenter: FavoritesInteractorOutput?
    
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
}

extension FavoritesInteractor: ObserverInteractorOutput {
    func update(list: [UUID : Product]) {
        if let product = list.first {
            products[product.key] = product.value
            products = products.filter { $0.value.isFavorite }
        }
        outputToPresenter?.products(list: products)
    }
}
