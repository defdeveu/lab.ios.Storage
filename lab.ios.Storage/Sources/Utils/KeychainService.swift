import Foundation

protocol KeychainService {
    func save(message: String)
    func readMessage() -> String?
}

final class SecureKeychainService {
    private static let service = "com.mycompany.keychain"
    private static let messageKey = "messageKey"

    private var options: [CFString: Any] {
        [kSecClass: kSecClassGenericPassword,
   kSecAttrService: Self.service,
   kSecAttrAccount: Self.messageKey,
kSecAttrAccessible: kSecAttrAccessibleAlways]
    }
}

extension SecureKeychainService: KeychainService {
    func save(message: String) {
        var query = options
        let data = message.data(using: .utf8)

        query[kSecValueData] = data

        let addResult = SecItemAdd(query as CFDictionary, nil)

        switch addResult {
        case errSecDuplicateItem:
            print("Item '\(Self.messageKey)' is already present in the storage")
        case errSecSuccess:
            return
        default:
            fatalError("Cannot store message")
        }

        // In case item is present already, update it
        let updateResult = SecItemUpdate(query as CFDictionary, [kSecValueData: data] as CFDictionary)

        switch updateResult {
        case errSecSuccess:
            return
        default:
            fatalError("Cannot update message \(updateResult as OSStatus)")
        }
    }

    func readMessage() -> String? {
        var query = options

        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                fatalError("Cannot read message")
            }
            return String(data: data, encoding: .utf8)
        case errSecItemNotFound:
            return nil
        default:
            print("Cannot read message - \(status)")
            fatalError("Cannot read message")
        }
    }
}
