import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(spacing: 20) {
            scenarioLink("User defaults", caseProvider: UserDefaultsCaseProvider())

            scenarioLink("Database", caseProvider: DatabaseCaseProvider())

            scenarioLink("File", caseProvider: FileCaseProvider())

            scenarioLink("Keychain", caseProvider: KeychainCaseProvider())
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { appTitle() }
    }

    @ToolbarContentBuilder
    private func appTitle() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            HStack {
                AppImages.appTitleImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .colorInvert()
                // TODO colorInvert as per the scheme
                Text(AppStrings.appTitle)
                    .font(.title.bold())
                    .foregroundColor(AppColors.navigationForeground)
            }
            .padding(.bottom, 8)
        }
    }

    @ViewBuilder
    private func scenarioLink(_ title: String,
                              caseProvider: CaseProviding) -> some View {
        NavigationLink(destination: CaseView(viewModel: CaseViewModel(caseProvider: caseProvider))) {
            Text(title)
        }
        .buttonStyle(SolidButtonStyle())
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
