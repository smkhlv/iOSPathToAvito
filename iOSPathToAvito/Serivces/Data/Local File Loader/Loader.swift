import Foundation

// Protocol defining methods for loading shop and product data
public protocol LoaderProtocol {
    
    // Method to fetch shop data
    func fetchShops() -> Result<[ShopDTO], Error>
    
    // Method to fetch product data
    func fetchProducts() -> Result<[ProductDTO], Error>
}

// Enumeration to represent errors that might occur during data loading
public enum LoaderError: Error {
    case decodeError
    case readFromFileError
}

public class Loader: JSONReadable, LoaderProtocol {
    
    public func fetchShops() -> Result<[ShopDTO], Error> {
        do {
            let jsonDataResult = try? readLocalJSONFile(forName: "shops")
            guard case .success(let jsonData) = jsonDataResult else {
                return .failure(LoaderError.readFromFileError)
            }
            let shops = try JSONDecoder().decode([ShopDTO].self, from: jsonData)
            return .success(shops)
        } catch {
            return .failure(LoaderError.decodeError)
        }
    }
    
    public func fetchProducts() -> Result<[ProductDTO], Error> {
        do {
            let jsonDataResult = try? readLocalJSONFile(forName: "products")
            guard case .success(let jsonData) = jsonDataResult else {
                return .failure(LoaderError.readFromFileError)
            }
            let products = try JSONDecoder().decode([ProductDTO].self, from: jsonData)
            return .success(products)
        } catch {
            return .failure(LoaderError.decodeError)
        }
    }
}
