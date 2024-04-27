import Foundation

public struct ProductDTO: Codable {
    let id: UUID
    let shopId: UUID?
    
    let title: String
    let description: String
    let price: String
    let linksToImages: [String]
}
