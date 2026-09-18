import Foundation

@MainActor
final class DatabaseCaseProvider: CaseProviding {
    private let databaseService: any DatabaseService

    init(databaseService: any DatabaseService = AppRepository.shared.databaseService) {
        self.databaseService = databaseService
    }

    func save(message: String) throws {
        try databaseService.save(message: message)
    }

    func readMessage() throws -> String? {
        try databaseService.readMessage()
    }
}
