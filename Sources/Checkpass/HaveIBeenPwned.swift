import Foundation
import SHA1

struct HaveIBeenPwned {
    enum Error: Swift.Error {
        case invalidData
    }
    
    private static let baseURL: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.pwnedpasswords.com"
        return components
    }()
    
    static func rangeSearch<Password>(forPassword password: Password) async throws -> Int
    where Password: StringProtocol {
        let digest = SHA1.hash(contentsOf: password.utf8).hexString()
        let prefix = digest.prefix(5)
        let suffix = digest.dropFirst(5)
        
        var components = Self.baseURL
        components.path = "/range/\(prefix)"
        
        var request = URLRequest(url: components.url!)
        request.setValue("true", forHTTPHeaderField: "Add-Padding")
        
        let data = try await URLSession.shared.data(for: request).0
        guard let result = String(data: data, encoding: .utf8) else {
            throw Error.invalidData
        }
        
        guard let lines = Lines(result) else {
            throw Error.invalidData
        }
        
        guard let count = lines
                .first(where: { $0.digest == suffix })?
                .count else {
            return 0
        }
        
        guard count > 0 else {
            throw Error.invalidData
        }
        
        return count
    }
}

fileprivate struct Lines: LosslessStringConvertible, Sequence {
    let lines: [Line]
    
    public init?(_ description: String) {
        lines = description
            .components(separatedBy: "\r\n")
            .map(Line.init(unchecked:))
        guard String(self) == description else {
            return nil
        }
    }
    
    var description: String {
        lines.map(String.init).joined(separator: "\r\n")
    }
    
    func makeIterator() -> Array<Line>.Iterator {
        lines.makeIterator()
    }
}

fileprivate struct Line: LosslessStringConvertible {
    let digest: String
    let count: Int
    
    init?(_ description: String) {
        self.init(unchecked: description)
        guard String(self) == description else {
            return nil
        }
    }
    
    init(unchecked description: String) {
        let columns = description.split(separator: ":")
        digest = String(columns.first ?? "")
        count = Int(columns.last ?? "0") ?? 0
        assert(String(self) == description)
    }
    
    var description: String {
        "\(digest):\(count)"
    }
}

fileprivate extension Sequence where Element == UInt8 {
    func hexString() -> String {
        self.map { String(format: "%02hhX", $0) }.joined()
    }
}
