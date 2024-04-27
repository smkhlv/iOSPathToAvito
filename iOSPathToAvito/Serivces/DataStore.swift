import Foundation

public protocol DataStoreProtocol: AnyObject {
    
    func setProducts(_ products: [UUID: Product])
    
    func setShops(_ shops: [UUID: Shop])
    
    func getProducts() -> [UUID: Product]
    
    func getShops() -> [UUID: Shop]
}

public class DataStore: DataStoreProtocol {
    
    private var products: [UUID: Product] = [:]
    private var shops: [UUID: Shop] = [:]
    
    public func setProducts(_ products: [UUID: Product]) {
        self.products = products
    }
    
    public func setShops(_ shops: [UUID: Shop]) {
        self.shops = shops
    }
    
    public func getProducts() -> [UUID: Product] {
        return products
    }
    
    public func getShops() -> [UUID: Shop] {
        return shops
    }
}
