import Foundation

@MainActor
protocol FileService {
    func save(message: String) throws
    func readMessage() throws -> String?
}

enum SandboxDirectoryType {
    case persistent
    case temporary
}

final class SandboxDirectoryService {
    private static let fileName = "message.txt"
    static let writeOptions: Data.WritingOptions = [.atomic, .completeFileProtection]

    private let directory: URL

    init(type: SandboxDirectoryType) {
        switch type {
        case .persistent:
            guard let directory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else {
                fatalError("Cannot get document path")
            }
            self.directory = directory
        case .temporary:
            directory = FileManager.default.temporaryDirectory
        }
    }

    init(directory: URL) {
        self.directory = directory
    }

    private var fileURL: URL {
        directory.appendingPathComponent(Self.fileName)
    }
}

extension SandboxDirectoryService: FileService {
    func save(message: String) throws {
        guard let data = message.data(using: .utf8) else {
            throw CocoaError(.fileWriteInapplicableStringEncoding)
        }
        try data.write(to: fileURL, options: Self.writeOptions)
    }

    func readMessage() throws -> String? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        let data = try Data(contentsOf: fileURL)
        return String(data: data, encoding: .utf8)
    }
}
