import Foundation

// Enum to define the data types
public enum DataType {
    case bd
    case cache
    case json
}

// Enum to define the query types
public enum QueryType {
    case favorites
    case bucket
    case productList
    case detail
}
public protocol ProductPredicateGenerator {
    func generate(dataType: DataType, queryType: QueryType) -> NSPredicate
}

public extension ProductPredicateGenerator {
    func generate(dataType: DataType, queryType: QueryType) -> NSPredicate {
        
        switch (dataType, queryType) {
        case (.bd, .favorites):
            return NSPredicate.equalPredicate(key: "_isFavorite", value: 1)
        case (.bd, .bucket):
            return NSPredicate.equalPredicate(key: "_isBucketInside", value: 1)
        case (.bd, .productList), (.bd, .detail):
            return NSPredicate.notNilPredicate(key: "id")
            
        case (.cache, .favorites):
            return NSPredicate.equalPredicate(key: "isFavorite", value: 1)
        case (.cache, .bucket):
            return NSPredicate.equalPredicate(key: "isBucketInside", value: 1)
        case (.cache, .productList), (.cache, .detail):
            return NSPredicate.notNilPredicate(key: "id")
            
        case (.json, .favorites):
            return NSPredicate.equalPredicate(key: "isFavorite", value: 1)
        case (.json, .bucket):
            return NSPredicate.equalPredicate(key: "isBucketInside", value: 1)
        case (.json, .productList), (.json, .detail):
            return NSPredicate.notNilPredicate(key: "id")
        }
    }
}
