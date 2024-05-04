import Foundation
import UIKit

// Protocol defining the input methods for the bucket list interactor
protocol BucketListInteractorInput: AnyObject {
    
    /// Method to handle changes in products
    /// - Parameter product: The dictionary containing the product to be changed
    func change(product: [UUID: Product])
}

// Protocol defining the output methods for the bucket list interactor
protocol BucketListInteractorOutput: AnyObject {
    func productFetchingError(title: String)
    func products(list: [UUID: Product])
}

final class BucketListInteractor: BucketListInteractorInput, ObserverInteractor {    
    var id: String = UUID().uuidString
    
    var products: [UUID : Product] = [:]
    
    public weak var output: ObserverInteractorOutput?
    public weak var outputToPresenter: BucketListInteractorOutput?
    public weak var subject: SubjectInteractorProtocol?
    private let loader: LoaderProtocol
    private let dataManager: DataServiceProtocol
    
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

extension BucketListInteractor: ObserverInteractorOutput {
    func update(list: [UUID : Product]) {
        if let product = list.first {
            products[product.key] = product.value
            products = products.filter { $0.value.isBucketInside }
        }
        outputToPresenter?.products(list: products)
    }
}
