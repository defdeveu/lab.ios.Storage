import Foundation

@MainActor
protocol CaseProviding: AnyObject {
    func save(message: String) throws
    func readMessage() throws -> String?
}
