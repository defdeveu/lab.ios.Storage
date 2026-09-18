import Foundation
import CoreData

@MainActor
protocol DatabaseService {
    func save(message: String) throws
    func readMessage() throws -> String?
}

@MainActor
final class CoreDataService {
    private static let messageKey = "message"
    private static let messageEntityName = String(describing: MessageEntity.self)
    private let persistentContainer: NSPersistentContainer

    init(with persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    private func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }

    private func getMessageObject() throws -> NSManagedObject? {
        let context = persistentContainer.viewContext
        let fetchResult = NSFetchRequest<NSManagedObject>(entityName: Self.messageEntityName)
        fetchResult.fetchLimit = 1
        return try context.fetch(fetchResult).first
    }
}

extension CoreDataService: DatabaseService {
    func save(message: String) throws {
        let messageObject: NSManagedObject

        if let object = try getMessageObject() {
            messageObject = object
        } else {
            let context = persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(
                forEntityName: Self.messageEntityName,
                in: context
            ) else {
                throw CocoaError(.persistentStoreInvalidType)
            }
            messageObject = NSManagedObject(entity: entity, insertInto: context)
        }

        messageObject.setValue(message, forKey: Self.messageKey)
        try saveContext()
    }

    func readMessage() throws -> String? {
        guard let messageObject = try getMessageObject() else { return nil }
        return messageObject.value(forKey: Self.messageKey) as? String
    }
}
