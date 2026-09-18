import Foundation
import Security

@MainActor
protocol KeychainService {
    func save(message: String) throws
    func readMessage() throws -> String?
}

@MainActor
final class SecureKeychainService {
    private let service: String
    private let account: String

    init(
        service: String = "dev.def.labs.storage",
        account: String = "message"
    ) {
        self.service = service
        self.account = account
    }

    private var identityQuery: [CFString: Any] {
        [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
    }
}

extension SecureKeychainService: KeychainService {
    func save(message: String) throws {
        guard let data = message.data(using: .utf8) else {
            throw CocoaError(.fileWriteInapplicableStringEncoding)
        }

        var addQuery = identityQuery
        KeychainPolicy.storageAttributes.forEach { addQuery[$0.key] = $0.value }
        addQuery[kSecValueData] = data

        let addResult = SecItemAdd(addQuery as CFDictionary, nil)

        switch addResult {
        case errSecDuplicateItem:
            var updatedAttributes = KeychainPolicy.storageAttributes
            updatedAttributes[kSecValueData] = data
            let status = SecItemUpdate(
                identityQuery as CFDictionary,
                updatedAttributes as CFDictionary
            )
            guard status == errSecSuccess else {
                throw KeychainServiceError.operationFailed(status)
            }
        case errSecSuccess:
            return
        default:
            throw KeychainServiceError.operationFailed(addResult)
        }
    }

    func readMessage() throws -> String? {
        var query = identityQuery

        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                throw KeychainServiceError.invalidData
            }
            return String(data: data, encoding: .utf8)
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainServiceError.operationFailed(status)
        }
    }
}

enum KeychainPolicy {
    static var storageAttributes: [CFString: Any] {
        [kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock]
    }
}

enum KeychainServiceError: LocalizedError {
    case invalidData
    case operationFailed(OSStatus)

    var errorDescription: String? {
        switch self {
        case .invalidData:
            "The Keychain returned data in an unexpected format."
        case let .operationFailed(status):
            SecCopyErrorMessageString(status, nil) as String?
                ?? "The Keychain operation failed with status \(status)."
        }
    }
}
