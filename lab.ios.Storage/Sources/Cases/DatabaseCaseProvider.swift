import Foundation

class DatabaseCaseProvider {
    @Published private var message: String?

    private let databaseService: DatabaseService

    init(databaseService: DatabaseService = AppRepository.shared.databaseService) {
        self.databaseService = databaseService
    }
}

extension DatabaseCaseProvider: CaseProviding {
    var messagePublisher: Published<String?>.Publisher {
        $message
    }

    func save(message: String) {
        databaseService.save(message: message)
    }

    func readMessage() {
        message = databaseService.readMessage()
    }
}
