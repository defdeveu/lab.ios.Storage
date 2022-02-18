import Foundation

protocol CaseProviding {
    var messagePublisher: Published<String?>.Publisher { get }

    func save(message: String)
    func readMessage()
}
