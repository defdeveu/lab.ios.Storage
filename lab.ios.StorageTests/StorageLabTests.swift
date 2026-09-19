import CoreData
import Foundation
import Security
import Testing
@testable import lab_ios_Storage

@MainActor
@Suite
struct CaseViewModelTests {
    @Test
    func saveDelegatesAndPresentsConfirmation() {
        let provider = RecordingCaseProvider()
        let viewModel = CaseViewModel(caseProvider: provider)

        viewModel.save(message: "Stored message")

        #expect(provider.savedMessages == ["Stored message"])
        #expect(viewModel.alertTitle == "Saved")
        #expect(viewModel.isAlertPresented)
    }

    @Test
    func readPresentsStoredMessage() {
        let provider = RecordingCaseProvider(storedMessage: "Recovered message")
        let viewModel = CaseViewModel(caseProvider: provider)

        viewModel.readMessage()

        #expect(viewModel.alertTitle == "Stored message")
        #expect(viewModel.alertMessage == "Recovered message")
        #expect(viewModel.isAlertPresented)
    }

    @Test
    func failureIsPresentedWithoutCrashing() {
        let provider = RecordingCaseProvider(error: TestError.failed)
        let viewModel = CaseViewModel(caseProvider: provider)

        viewModel.save(message: "message")

        #expect(viewModel.alertTitle == "Save failed")
        #expect(viewModel.alertMessage == TestError.failed.localizedDescription)
    }
}

@MainActor
@Suite
struct SandboxDirectoryServiceTests {
    @Test
    func roundTripsUTF8Message() throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )
        defer { try? FileManager.default.removeItem(at: directory) }

        let service = SandboxDirectoryService(directory: directory)
        try service.save(message: "Árvíztűrő tükörfúrógép")

        #expect(try service.readMessage() == "Árvíztűrő tükörfúrógép")
    }

    @Test
    func missingFileReturnsNil() throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let service = SandboxDirectoryService(directory: directory)

        #expect(try service.readMessage() == nil)
    }

    @Test
    func solutionAddsCompleteProtectionToFileWrites() {
        #expect(SandboxDirectoryService.writeOptions == [.atomic, .completeFileProtection])
    }
}

@Suite
struct StoragePolicyTests {
    @Test
    func solutionUsesCompleteProtectionForPersistentStore() {
        let description = NSPersistentStoreDescription()

        PersistentStorePolicy.configure(description)

        #expect(description.options[NSPersistentStoreFileProtectionKey] as? String == FileProtectionType.complete.rawValue)
    }

    @Test
    func solutionUsesDeviceOnlyKeychainAccessibilityInSimulator() {
        let accessibility = KeychainPolicy.storageAttributes[kSecAttrAccessible] as? String

        #expect(accessibility == kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String)
    }
}

@MainActor
private final class RecordingCaseProvider: CaseProviding {
    private(set) var savedMessages: [String] = []
    private let storedMessage: String?
    private let error: (any Error)?

    init(storedMessage: String? = nil, error: (any Error)? = nil) {
        self.storedMessage = storedMessage
        self.error = error
    }

    func save(message: String) throws {
        if let error {
            throw error
        }
        savedMessages.append(message)
    }

    func readMessage() throws -> String? {
        if let error {
            throw error
        }
        return storedMessage
    }
}

private enum TestError: LocalizedError {
    case failed

    var errorDescription: String? {
        "The test storage failed."
    }
}