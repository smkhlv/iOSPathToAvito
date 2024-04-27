import Foundation

public protocol LoaderProtocol {
    
    func fetchShops() throws -> Result<[ShopDTO], LoaderError>
    
    func fetchProducts() throws -> Result<[ProductDTO], LoaderError>
}

public enum LoaderError: Error {
    case decodeError
    case readFromFileError
}

public class Loader: JSONReadable, LoaderProtocol {
    
    public func fetchShops() throws -> Result<[ShopDTO], LoaderError> {
        do {
            let jsonDataResult = try? readLocalJSONFile(forName: "shops")
            guard case .success(let jsonData) = jsonDataResult else {
                return .failure(.readFromFileError)
            }
            let shops = try JSONDecoder().decode([ShopDTO].self, from: jsonData)
            return .success(shops)
        } catch {
            return .failure(.decodeError)
        }
    }
    
    public func fetchProducts() throws -> Result<[ProductDTO], LoaderError> {
        do {
            let jsonDataResult = try? readLocalJSONFile(forName: "products")
            guard case .success(let jsonData) = jsonDataResult else {
                return .failure(.readFromFileError)
            }
            let products = try JSONDecoder().decode([ProductDTO].self, from: jsonData)
            return .success(products)
        } catch {
            return .failure(.decodeError)
        }
    }
}
