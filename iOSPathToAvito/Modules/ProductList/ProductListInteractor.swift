import Foundation
import UIKit

protocol ProductListInteractorInput: AnyObject {
    // fetching some data
    
    func fetchProducts()
    
    func changeOfProductBucketState(id: UUID?)
    
    func chageOfProductFavoriteState(id: UUID?)
}

protocol ProductListInteractorOutput: AnyObject {
    // result of fetching
    
    func productFetchingError(title: String)
    
    func products(list: [UUID: Product])
}

final class ProductListInteractor: ProductListInteractorInput {
    
    public weak var output: ProductListInteractorOutput?
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
    
    func fetchProducts() {
        
        let products = dataStore.getProducts()
        
        if products.isEmpty {
            guard let result = try? loader.fetchProducts() else {
                return
            }
            switch result {
            case .success(let success):
                let convertedFromDTO = success.map {
                    Product(
                        id: $0.id,
                        shopId: $0.shopId,
                        title: $0.title,
                        description: $0.description,
                        price: $0.price,
                        images: []
                    )
                }
                let convertedFromDTODic: [UUID: Product] = Dictionary(uniqueKeysWithValues: convertedFromDTO.map { ($0.id, $0) })
                
                dataStore.setProducts(convertedFromDTODic)
                output?.products(list: convertedFromDTODic)
            case .failure(let failure):
                output?.productFetchingError(title: failure.localizedDescription)
            }
        } else {
            output?.products(list: products)
        }
    }
}
