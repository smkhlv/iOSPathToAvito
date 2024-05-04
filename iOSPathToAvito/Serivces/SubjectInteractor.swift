// Protocol defining methods for interacting with subjects and observing changes
public protocol SubjectInteractorProtocol: ChangeableProductProtocol {
    // Array to hold observers
    var observers: [ObserverInteractor] { get set }
    
    // Method to add an observer
    func add(_ observer: ObserverInteractor)
    
    // Method to remove an observer
    func remove(_ observer: ObserverInteractor)
}

// Default implementation of methods to add and remove observers
public extension SubjectInteractorProtocol {

    func add(_ observer: ObserverInteractor) {
        observers.append(observer)
    }
    

    func remove(_ observer: ObserverInteractor) {
        for (index, registeredObserver) in observers.enumerated() {
            if registeredObserver.id == observer.id {
                self.observers.remove(at: index)
            }
        }
    }
}

// Concrete implementation of SubjectInteractorProtocol
public final class SubjectInteractor: SubjectInteractorProtocol {

    public var observers: [ObserverInteractor] = []

    public func createProduct(_ product: Product) {
        observers.forEach { $0.createProduct(product) }
    }
    
    public func updateProduct(_ product: Product) {
        observers.forEach { $0.updateProduct(product) }
    }
    
    public func deleteProduct(_ product: Product) {
        observers.forEach { $0.deleteProduct(product) }
    }
}
