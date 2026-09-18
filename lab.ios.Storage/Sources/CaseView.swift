import SwiftUI

struct CaseView: View {
    @State private var viewModel: CaseViewModel
    @State private var message = ""

    init(viewModel: CaseViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        VStack(alignment: .leading, spacing: 20) {
            Text("Message")
                .font(.headline)

            TextField("Enter a message", text: $message, axis: .vertical)
                .textInputAutocapitalization(.sentences)
                .lineLimit(3, reservesSpace: true)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(AppColors.textInputOverlay, lineWidth: 1)
                )

            Button("Save") {
                viewModel.save(message: message)
            }
            .buttonStyle(SolidButtonStyle())
            .disabled(message.isEmpty)

            Button("Read") {
                viewModel.readMessage()
            }
            .buttonStyle(SolidButtonStyle())

            Spacer()
        }
        .padding(20)
        .navigationBarTitleDisplayMode(.inline)
        .alert(viewModel.alertTitle, isPresented: $viewModel.isAlertPresented) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}
