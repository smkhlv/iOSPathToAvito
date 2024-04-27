import Foundation
import UIKit

protocol BucketListInteractorInput: AnyObject {
    // fetching some data
    
    func updateProductList()
    
    func changeOfProductBucketState(id: UUID?)
    
    func chageOfProductFavoriteState(id: UUID?)
}

protocol BucketListInteractorOutput: AnyObject {
    // result of fetching
    
    func productFetchingError(title: String)
    
    func products(list: [UUID: Product])
}

public enum BucketListInteractorError: Error {
    case noData
}

final class BucketListInteractor: BucketListInteractorInput {
    
    public weak var output: BucketListInteractorOutput?
    private let loader: LoaderProtocol
    private let dataStore: DataStoreProtocol
    
    init(loader: LoaderProtocol, dataStore: DataStoreProtocol) {
        self.loader = loader
        self.dataStore = dataStore
    }
    
    func changeOfProductBucketState(id: UUID?) {
        guard let id = id else {
            return
        }
        let products = dataStore.getProducts()
        let productToChange = products[id]
        productToChange?.isBucketInside = productToChange?.isBucketInside == true ? false : true
        output?.products(list: products)
    }
    
    func chageOfProductFavoriteState(id: UUID?) {
        guard let id = id else {
            return
        }
        let products = dataStore.getProducts()
        let productToChange = products[id]
        productToChange?.isFavorite = productToChange?.isFavorite == true ? false : true
        output?.products(list: products)
    }
    
    func updateProductList() {
        let products = dataStore.getProducts().filter { $0.value.isBucketInside }
        output?.products(list: products)
    }
}
