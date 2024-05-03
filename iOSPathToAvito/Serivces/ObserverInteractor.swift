import Foundation

public protocol ObserverInteractorOutput: AnyObject {
    func update(list: [UUID: Product])
}

public protocol ObserverInteractor: AnyObject {
    
    var id: String { get }
    
    var output: ObserverInteractorOutput? { get set }
    
    var products: [UUID: Product] { get set }
    
    func createProduct(_ product: Product)
    
    func updateProduct(_ product: Product)
    
    func deleteProduct(_ product: Product)
}

extension ObserverInteractor {
    func createProduct(_ product: Product) {
        if let id = product.id {
            products[id] = product
            output?.update(list: products)
        }
    }
    
    func updateProduct(_ product: Product) {
        if let id = product.id {
            products[id] = product
            output?.update(list: products)
        }
    }
    
    func deleteProduct(_ product: Product) {
        if let id = product.id {
            products.removeValue(forKey: id)
            output?.update(list: products)
        }
    }
}
