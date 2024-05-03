public protocol SubjectInteractorProtocol: ChangebaleProductProtocol {
    var observers: [ObserverInteractor] { get set }
    
    func add(_ observer: ObserverInteractor)
    func remove(_ observer: ObserverInteractor)
}

public extension SubjectInteractorProtocol {
    func add(_ observer: ObserverInteractor) {
        observers.append(observer)
    }
    
    func remove(_ observer: ObserverInteractor) {
        for (index, registerdObserver) in observers.enumerated() {
            if registerdObserver.id == observer.id {
                self.observers.remove(at: index)
            }
        }
    }
}

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
