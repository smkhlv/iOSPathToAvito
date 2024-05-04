import Foundation

// Protocol defining methods for creating a product
public protocol CreatableProductProtocol: AnyObject {
    func createProduct(_ product: Product)
}

// Protocol defining methods for updating a product
public protocol UpdatableProductProtocol: AnyObject {
    func updateProduct(_ product: Product)
}

// Protocol defining methods for deleting a product
public protocol DeletableProductProtocol: AnyObject {
    func deleteProduct(_ product: Product)
}

// Typealias combining protocols for creating, updating, and deleting products
public typealias ChangeableProductProtocol =
CreatableProductProtocol &
UpdatableProductProtocol &
DeletableProductProtocol

