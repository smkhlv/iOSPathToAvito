public enum OperationType {
    case append
    case delete
    case update
}

public protocol ProductDifferencable {
    func compare(oldArray: [Product], newArray: [Product]) -> [OperationType: [Product]]
}

public extension ProductDifferencable {
    
    // Method to compare and process arrays
     func compare(oldArray: [Product], newArray: [Product]) -> [OperationType: [Product]] {
        var result: [OperationType: [Product]] = [.append: [], .delete: [], .update: []]
        
        let oldDict = Dictionary(uniqueKeysWithValues: oldArray.compactMap { ($0.id, $0) })
        let newDict = Dictionary(uniqueKeysWithValues: newArray.compactMap { ($0.id, $0) })
        
        // Find items to delete
        for oldItem in oldArray {
            if newDict[oldItem.id!] == nil {
                result[.delete]?.append(oldItem)
            }
        }
        
        // Find items to append and update
        for newItem in newArray {
            if let oldItem = oldDict[newItem.id!] {
                if !oldItem.isEqualTo(newItem) {
                    result[.update]?.append(newItem)
                }
            } else {
                result[.append]?.append(newItem)
            }
        }
        
        return result
    }
}
