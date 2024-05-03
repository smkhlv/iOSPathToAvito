import Foundation
import UIKit

protocol BucketListInteractorInput: AnyObject {
    func change(product: [UUID: Product])
    
    func subjectObject() -> SubjectInteractorProtocol?
}

protocol BucketListInteractorOutput: AnyObject {
    func productFetchingError(title: String)
    
    func products(list: [UUID: Product])
}

final class BucketListInteractor: BucketListInteractorInput, ObserverInteractor {    
    var id: String = UUID().uuidString
    
    var products: [UUID : Product] = [:]
    
    public weak var output: ObserverInteractorOutput?
    public weak var outputToPresenter: BucketListInteractorOutput?
    private let loader: LoaderProtocol
    private let dataManager: DS
    public var subject: SubjectInteractorProtocol?
    
    func subjectObject() -> SubjectInteractorProtocol? {
        return subject
    }
    
    init(loader: LoaderProtocol, dataManager: DS) {
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

extension BucketListInteractor: ObserverInteractorOutput {
    func update(list: [UUID : Product]) {
        if let product = list.first {
            products[product.key] = product.value
            products = products.filter { $0.value.isBucketInside }
        }
        outputToPresenter?.products(list: products)
    }
}
