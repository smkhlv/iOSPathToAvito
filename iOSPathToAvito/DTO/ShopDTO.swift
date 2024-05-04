import Foundation

// Structure representing a Data Transfer Object (DTO) for shop data
public struct ShopDTO: Codable {
    let id: UUID
    
    let city: String
    let adress: String
    let phoneNumber: Int
    let email: String
    let linkToImage: String
    let productIds: [UUID?]
}
