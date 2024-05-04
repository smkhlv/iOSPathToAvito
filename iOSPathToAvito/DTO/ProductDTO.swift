import Foundation

// Structure representing a Data Transfer Object (DTO) for product data
public struct ProductDTO: Codable {
    let id: UUID
    let shopId: UUID?
    
    let title: String
    let description: String
    let price: String
    let linksToImages: [String]
}
