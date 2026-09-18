import SwiftUI

@main
struct StorageLabApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColors.navigationBackground)

        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.navigationForeground)
        ]

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MenuView()
            }
            .tint(AppColors.navigationForeground)
        }
    }
}
