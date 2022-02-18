import SwiftUI

struct CaseView: View {
    @StateObject private var viewModel: CaseViewModel
    @State private var message = ""

    init(viewModel: CaseViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 20) {
            TextField("message", text: $message)
                .padding(.horizontal, 10)
                .frame(height: 44)
                .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(AppColors.textInputOverlay, lineWidth: 1))
                .padding(.top, 50)
                .padding(.bottom, 30)

            Button("Save") {
                viewModel.save(message: message)
            }.buttonStyle(SolidButtonStyle())

            Button("Read", action: viewModel.readMessage)
                .buttonStyle(SolidButtonStyle())

            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(title: Text(viewModel.alertMessage))
        })
    }
}
