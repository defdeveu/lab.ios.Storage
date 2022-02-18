import Foundation
import CoreData

protocol DatabaseService {
    func save(message: String)
    func readMessage() -> String?
}

final class CoreDataService {
    private static let messageKey = "message"
    private static let messageEntityName = String(describing: MessageEntity.self)
    private let persistentContainer: NSPersistentContainer

    init(with persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Cannot save context \(error), \(error.userInfo)")
            }
        }
    }

    private func getMessageObject() -> NSManagedObject? {
        let context = persistentContainer.viewContext
        let fetchResult = NSFetchRequest<NSManagedObject>(entityName: Self.messageEntityName)

        do {
            return try context.fetch(fetchResult).first
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}

extension CoreDataService: DatabaseService {
    func save(message: String) {
        let messageObject: NSManagedObject

        if let object = getMessageObject() {
            messageObject = object
        } else {
            let context = persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: Self.messageEntityName,
                                                    in: context)!
            messageObject = NSManagedObject(entity: entity, insertInto: context)
        }

        messageObject.setValue(message, forKey: Self.messageKey)

        saveContext()
    }

    func readMessage() -> String? {
        guard let messageObject = getMessageObject() else { return nil }
        return messageObject.value(forKey: Self.messageKey) as? String
    }
}
