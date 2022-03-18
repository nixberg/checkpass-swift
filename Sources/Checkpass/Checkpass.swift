import ArgumentParser

@main
struct Checkpass: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Checks a password against the Pwned Passwords API.")
    
    @Argument(help: ArgumentHelp(
        "The password to check.",
        discussion: "If no input is provided, the tool reads from stdin."))
    var password: String?
    
    @Flag(help: "Silent mode.")
    var silent = false
    
    func run() async throws {
        guard let password = password ?? readLine() else {
            throw ValidationError("Missing expected argument '<password>'")
        }
        
        let count = try await HaveIBeenPwned.rangeSearch(forPassword: password)
        
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
        
        guard count == 0 else {
            throw ExitCode.failure
        }
    }
}
