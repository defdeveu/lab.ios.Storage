import Foundation

@MainActor
final class UserDefaultsCaseProvider: CaseProviding {
    private static let messageKey = "messageKey"
    private let userDefaultsService: any UserDefaultsService

    init(userDefaultsService: any UserDefaultsService = AppRepository.shared.userDefaultsService) {
        self.userDefaultsService = userDefaultsService
    }

    func save(message: String) throws {
        userDefaultsService.set(message, forKey: Self.messageKey)
    }

    func readMessage() throws -> String? {
        userDefaultsService.string(forKey: Self.messageKey)
    }
}
