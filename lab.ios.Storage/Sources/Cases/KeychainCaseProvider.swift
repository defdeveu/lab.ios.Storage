import Foundation

class KeychainCaseProvider {
    @Published private var message: String?

    private let keychainService: KeychainService

    init(keychainService: KeychainService = AppRepository.shared.keychainService) {
        self.keychainService = keychainService
    }
}

extension KeychainCaseProvider: CaseProviding {
    var messagePublisher: Published<String?>.Publisher {
        $message
    }

    func save(message: String) {
        keychainService.save(message: message)
    }

    func readMessage() {
        message = keychainService.readMessage()
    }
}
