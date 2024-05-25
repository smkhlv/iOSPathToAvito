extension Array where Element == Product {
    
    public func hasChanges(with products: [Product]) -> Bool {
        for product in products {
           let result = self.filter { $0.isBucketInside != product.isBucketInside || $0.isFavorite != product.isFavorite }
            if !result.isEmpty {
                return !result.isEmpty
            }
            continue
        }
        return false
    }
}
