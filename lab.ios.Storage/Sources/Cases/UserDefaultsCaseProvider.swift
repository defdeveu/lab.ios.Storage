import Foundation

class UserDefaultsCaseProvider {
    private static let messageKey = "messageKey"

    @Published private var message: String?

    private let userDefaultsService: UserDefaultsService

    init(userDefaultsService: UserDefaultsService = AppRepository.shared.userDefaultsService) {
        self.userDefaultsService = userDefaultsService
    }
}

extension UserDefaultsCaseProvider: CaseProviding {
    var messagePublisher: Published<String?>.Publisher {
        $message
    }

    func save(message: String) {
        userDefaultsService.set(message, forKey: Self.messageKey)
    }

    func readMessage() {
        message = userDefaultsService.string(forKey: Self.messageKey)
    }
}
