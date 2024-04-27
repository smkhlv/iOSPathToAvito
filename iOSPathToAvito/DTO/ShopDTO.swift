import Foundation

public struct ShopDTO: Codable {
    let id: UUID
    
    let city: String
    let adress: String
    let phoneNumber: Int
    let email: String
    let linkToImage: String
    let productIds: [UUID?]
}
