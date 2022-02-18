import Foundation
import Combine

class CaseViewModel: ObservableObject {
    private let caseProvider: CaseProviding

    private var cancellables: Set<AnyCancellable> = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    init(caseProvider: CaseProviding) {
        self.caseProvider = caseProvider

        self.caseProvider.messagePublisher.sink { [weak self] message in
            self?.alertMessage = message ?? ""
            self?.showAlert = !(message?.isEmpty ?? true)
        }.store(in: &cancellables)
    }

    func save(message: String) {
        caseProvider.save(message: message)
    }

    func readMessage() {
        caseProvider.readMessage()
    }
}
