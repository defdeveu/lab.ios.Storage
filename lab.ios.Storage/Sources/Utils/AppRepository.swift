import Foundation
import CoreData

// MARK: - Application Services

final class AppRepository {
    static var shared = AppRepository()
    private init() { }

    lazy var userDefaultsService: UserDefaultsService = {
        UserDefaults.standard
    }()

    lazy var databaseService: DatabaseService = {
        let persistentContainer = NSPersistentContainer(name: "AppStorage")
        persistentContainer.persistentStoreDescriptions.first?.setOption(FileProtectionType.complete as NSObject,
                                                                         forKey: NSPersistentStoreFileProtectionKey)
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Cannot create persistentContainer \(error), \(error.userInfo)")
            }
        })

        return CoreDataService(with: persistentContainer)
    }()

    lazy var persistentFileService: FileService = {
        SandboxDirectoryService(type: .persistent)
    }()

    lazy var temporaryFileService: FileService = {
        SandboxDirectoryService(type: .temporary)
    }()

    lazy var keychainService: KeychainService = {
        SecureKeychainService()
    }()
}
