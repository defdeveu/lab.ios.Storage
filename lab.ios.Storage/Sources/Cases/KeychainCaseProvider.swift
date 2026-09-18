import Foundation

@MainActor
final class KeychainCaseProvider: CaseProviding {
    private let keychainService: any KeychainService

    init(keychainService: any KeychainService = AppRepository.shared.keychainService) {
        self.keychainService = keychainService
    }

    func save(message: String) throws {
        try keychainService.save(message: message)
    }

    func readMessage() throws -> String? {
        try keychainService.readMessage()
    }
}
