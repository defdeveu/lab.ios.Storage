import SwiftUI

struct MenuView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Store and retrieve the same message using each API, then inspect how the result is represented on the device.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)

                scenarioLink(
                    "UserDefaults",
                    detail: "Preference storage",
                    caseProvider: UserDefaultsCaseProvider()
                )
                scenarioLink(
                    "Core Data",
                    detail: "SQLite-backed object storage",
                    caseProvider: DatabaseCaseProvider()
                )
                scenarioLink(
                    "File",
                    detail: "A document in the application sandbox",
                    caseProvider: FileCaseProvider()
                )
                scenarioLink(
                    "Keychain",
                    detail: "A generic-password item",
                    caseProvider: KeychainCaseProvider()
                )
            }
            .padding(20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { appTitle() }
    }

    @ToolbarContentBuilder
    private func appTitle() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            HStack(spacing: 10) {
                AppImages.appTitleImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .colorInvert()
                    .accessibilityHidden(true)
                Text(AppStrings.appTitle)
                    .font(.headline.bold())
                    .foregroundStyle(AppColors.navigationForeground)
            }
        }
    }

    private func scenarioLink(
        _ title: String,
        detail: String,
        caseProvider: any CaseProviding
    ) -> some View {
        NavigationLink {
            CaseView(viewModel: CaseViewModel(caseProvider: caseProvider))
                .navigationTitle(title)
        } label: {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote.bold())
            }
            .frame(maxWidth: .infinity, minHeight: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(StorageCardButtonStyle())
    }
}

#Preview {
    NavigationStack {
        MenuView()
    }
    .preferredColorScheme(.dark)
}
