import Foundation
public protocol CreatableProductProtocol: AnyObject {
    
    func createProduct(_ product: Product)
}

public protocol UpdatableProductProtocol: AnyObject {
    
    func updateProduct(_ product: Product)
}

public protocol DeletableProductProtocol: AnyObject {
    
    func deleteProduct(_ product: Product)
}

public typealias ChangebaleProductProtocol = CreatableProductProtocol & UpdatableProductProtocol & DeletableProductProtocol
