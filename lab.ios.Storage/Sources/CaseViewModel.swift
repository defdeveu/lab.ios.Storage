import Foundation
import Observation

@MainActor
@Observable
final class CaseViewModel {
    private let caseProvider: any CaseProviding

    var isAlertPresented = false
    private(set) var alertTitle = ""
    private(set) var alertMessage = ""

    init(caseProvider: any CaseProviding) {
        self.caseProvider = caseProvider
    }

    func save(message: String) {
        do {
            try caseProvider.save(message: message)
            presentAlert(title: "Saved", message: "The message was stored.")
        } catch {
            presentAlert(title: "Save failed", message: error.localizedDescription)
        }
    }

    func readMessage() {
        do {
            let message = try caseProvider.readMessage() ?? "No stored message was found."
            presentAlert(title: "Stored message", message: message)
        } catch {
            presentAlert(title: "Read failed", message: error.localizedDescription)
        }
    }

    private func presentAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        isAlertPresented = true
    }
}
