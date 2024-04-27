import Foundation

public protocol JSONReadable {
    func readLocalJSONFile(forName name: String) throws -> Result<Data, JSONError>
}

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
