import Foundation

// Protocol defining a method for reading local JSON files
public protocol JSONReadable {
    func readLocalJSONFile(forName name: String) throws -> Result<Data, JSONError>
}

// Enumeration to represent errors that might occur during JSON reading
public enum JSONError: Error {
    case fileNotFound
    case fileReadFailed
}

extension JSONReadable {
    public func readLocalJSONFile(forName name: String) throws -> Result<Data, JSONError> {
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: "json") else {
            return .failure(.fileNotFound)
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return .success(data)
        } catch {
            return .failure(.fileReadFailed)
        }
    }
}
