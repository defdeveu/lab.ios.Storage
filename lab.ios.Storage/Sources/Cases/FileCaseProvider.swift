import Foundation

@MainActor
final class FileCaseProvider: CaseProviding {
    private let fileService: any FileService

    init(fileService: any FileService = AppRepository.shared.persistentFileService) {
        self.fileService = fileService
    }

    func save(message: String) throws {
        try fileService.save(message: message)
    }

    func readMessage() throws -> String? {
        try fileService.readMessage()
    }
}
