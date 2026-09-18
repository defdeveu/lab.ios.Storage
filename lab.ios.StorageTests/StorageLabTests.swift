import CoreData
import Foundation
import Security
import XCTest
@testable import lab_ios_Storage

@MainActor
final class CaseViewModelTests: XCTestCase {
    func testSaveDelegatesAndPresentsConfirmation() {
        let provider = RecordingCaseProvider()
        let viewModel = CaseViewModel(caseProvider: provider)

        viewModel.save(message: "Stored message")

        XCTAssertEqual(provider.savedMessages, ["Stored message"])
        XCTAssertEqual(viewModel.alertTitle, "Saved")
        XCTAssertTrue(viewModel.isAlertPresented)
    }

    func testReadPresentsStoredMessage() {
        let provider = RecordingCaseProvider(storedMessage: "Recovered message")
        let viewModel = CaseViewModel(caseProvider: provider)

        viewModel.readMessage()

        XCTAssertEqual(viewModel.alertTitle, "Stored message")
        XCTAssertEqual(viewModel.alertMessage, "Recovered message")
        XCTAssertTrue(viewModel.isAlertPresented)
    }

    func testFailureIsPresentedWithoutCrashing() {
        let provider = RecordingCaseProvider(error: TestError.failed)
        let viewModel = CaseViewModel(caseProvider: provider)

        viewModel.save(message: "message")

        XCTAssertEqual(viewModel.alertTitle, "Save failed")
        XCTAssertEqual(viewModel.alertMessage, TestError.failed.localizedDescription)
    }
}

@MainActor
final class SandboxDirectoryServiceTests: XCTestCase {
    func testRoundTripsUTF8Message() throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )
        defer { try? FileManager.default.removeItem(at: directory) }

        let service = SandboxDirectoryService(directory: directory)
        try service.save(message: "Árvíztűrő tükörfúrógép")

        XCTAssertEqual(try service.readMessage(), "Árvíztűrő tükörfúrógép")
    }

    func testMissingFileReturnsNil() throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let service = SandboxDirectoryService(directory: directory)

        XCTAssertNil(try service.readMessage())
    }

    func testChallengeUsesOnlyAtomicFileWrites() {
        XCTAssertEqual(SandboxDirectoryService.writeOptions, [.atomic])
    }
}

final class StoragePolicyTests: XCTestCase {
    func testChallengeLeavesPersistentStoreProtectionUnspecified() {
        let description = NSPersistentStoreDescription()

        PersistentStorePolicy.configure(description)

        XCTAssertNil(description.options[NSPersistentStoreFileProtectionKey])
    }

    func testChallengeKeychainItemRemainsAvailableAfterFirstUnlock() {
        let accessibility = KeychainPolicy.storageAttributes[kSecAttrAccessible] as? String

        XCTAssertEqual(accessibility, kSecAttrAccessibleAfterFirstUnlock as String)
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
