import Foundation

protocol FileService {
    func save(message: String)
    func readMessage() -> String?
}

enum SandboxDirectoryType {
    case persistent
    case temporary
}

final class SandboxDirectoryService {
    private static let fileName = "message.txt"
    private let type: SandboxDirectoryType

    init(type: SandboxDirectoryType) {
        self.type = type
    }

    private func fileFullPath() -> URL {
        let path: URL
        switch type {
        case .persistent:
            guard let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                fatalError("Cannot get document path")
            }
            path = docPath
        case .temporary:
            path = FileManager.default.temporaryDirectory
        }

        return path.appendingPathComponent(Self.fileName)
    }
}

extension SandboxDirectoryService: FileService {
    func save(message: String) {
        let filePath = fileFullPath()
        do {
            let data = message.data(using: .utf8)
            try data?.write(to: filePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Cannot save message to file \(filePath.absoluteString): \(error)")
        }
    }

    func readMessage() -> String? {
        let filePath = fileFullPath()

        do {
            let data = try Data(contentsOf: filePath)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Cannot read message from file \(filePath.absoluteString): \(error)")
            return nil
        }
    }
}
