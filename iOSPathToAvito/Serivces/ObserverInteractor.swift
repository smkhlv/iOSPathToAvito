import Foundation

// Protocol defining the output method for updating a list of products
public protocol ObserverInteractorOutput: AnyObject {
    func update(list: [UUID: Product])
}

// Protocol defining methods and properties for an observer interactor
public protocol ObserverInteractor: AnyObject {
    // Unique identifier for the observer
    var id: String { get }
    
    // Output delegate to communicate changes
    var output: ObserverInteractorOutput? { get set }
    
    // Dictionary to store products
    var products: [UUID: Product] { get set }
    
    // Method to handle creation of a product
    func createProduct(_ product: Product)
    
    // Method to handle updating a product
    func updateProduct(_ product: Product)
    
    // Method to handle deletion of a product
    func deleteProduct(_ product: Product)
}

// Default implementation of observer interactor methods
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
