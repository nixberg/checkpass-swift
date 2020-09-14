import ArgumentParser
import Foundation
import SHA1

struct Checkpass: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Checks a password against the Pwned Passwords API.")
    
    @Argument(help: ArgumentHelp(
        "The password to check.",
        discussion: "If no input file is provided, the tool reads from stdin."))
    var password: String?
    
    @Flag(help: "Silent mode.")
    var silent = false
    
    func run() throws {
        guard let password = self.password ?? readLine() else {
            throw ValidationError("Missing expected argument '<password>'")
        }
        
        let digest = SHA1.hash(ArraySlice(password.utf8)).hex()
        let suffix = digest.dropFirst(5)
        
        let url = "https://api.pwnedpasswords.com/range/\(digest.prefix(5))"
        let lines = try String(contentsOf: URL(string: url)!)
        
        let count = lines.split(whereSeparator: \.isNewline).compactMap {
            let columns = $0.split(separator: ":")
            guard columns.count == 2 else {
                return nil
            }
            guard let count = Int(columns[1]) else {
                return nil
            }
            return columns[0].lowercased() == suffix ? count : nil
        }.first ?? 0
        
        if !silent {
            switch count {
            case 0:
                print("Password not found.")
            case 1:
                print("Password found!")
            default:
                print("Password found \(count) times!")
            }
        }
        
        if count > 0 {
            throw ExitCode.failure
        }
    }
}

extension DataProtocol {
    func hex() -> String {
        self.map { String(format: "%02hhx", $0) }.joined()
    }
}

Checkpass.main()
