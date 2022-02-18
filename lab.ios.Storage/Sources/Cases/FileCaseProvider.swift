import Foundation

class FileCaseProvider {
    @Published private var message: String?

    private let fileService: FileService

    // NOTE: experiments are possible with both persistent and temporary file services
    init(fileService: FileService = AppRepository.shared.persistentFileService) {
        self.fileService = fileService
    }
}

extension FileCaseProvider: CaseProviding {
    var messagePublisher: Published<String?>.Publisher {
        $message
    }

    func save(message: String) {
        fileService.save(message: message)
    }

    func readMessage() {
        message = fileService.readMessage()
    }
}
