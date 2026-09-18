import Foundation

@MainActor
protocol UserDefaultsService {
    func string(forKey: String) -> String?
    func set(_ value: Any?, forKey: String)
}

extension UserDefaults: UserDefaultsService {}
