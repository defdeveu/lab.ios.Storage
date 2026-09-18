import Foundation
import CoreData

@MainActor
final class AppRepository {
    static let shared = AppRepository()
    private init() { }

    lazy var userDefaultsService: any UserDefaultsService = {
        UserDefaults.standard
    }()

    lazy var databaseService: any DatabaseService = {
        let persistentContainer = NSPersistentContainer(name: "AppStorage")
        if let description = persistentContainer.persistentStoreDescriptions.first {
            PersistentStorePolicy.configure(description)
        }
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Cannot create persistentContainer \(error), \(error.userInfo)")
            }
        }

        return CoreDataService(with: persistentContainer)
    }()

    lazy var persistentFileService: any FileService = {
        SandboxDirectoryService(type: .persistent)
    }()

    lazy var temporaryFileService: any FileService = {
        SandboxDirectoryService(type: .temporary)
    }()

    lazy var keychainService: any KeychainService = {
        SecureKeychainService()
    }()
}

enum PersistentStorePolicy {
    static func configure(_ description: NSPersistentStoreDescription) {
        description.setOption(
            FileProtectionType.complete as NSObject,
            forKey: NSPersistentStoreFileProtectionKey
        )
    }
}
