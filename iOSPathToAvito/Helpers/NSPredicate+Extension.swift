import Foundation

public extension NSPredicate {
    static func equalPredicate(key: String, value: Any) -> NSPredicate {
        return NSPredicate(format: "%K == %@", argumentArray: [key, value])
    }
    
    static func notNilPredicate(key: String) -> NSPredicate {
        return NSPredicate(format: "%K != nil", key)
    }
}
