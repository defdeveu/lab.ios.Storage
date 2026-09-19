import SwiftUI

// MARK: - Button style

struct SolidButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .frame(minHeight: 48)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Spacer()
        }
        .foregroundStyle(AppColors.buttonText)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.buttonBackground)
        )
        .font(.headline)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.buttonOverlay, lineWidth: 2)
        )
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .padding([.top, .bottom], 8)
    }
}

struct StorageCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundStyle(AppColors.buttonText)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColors.buttonBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(AppColors.buttonOverlay, lineWidth: 1)
                    }
            )
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}

// MARK: - Colors

enum AppColors {
    static let navigationBackground = Color(uiColor: .systemBackground)
    static let navigationForeground = Color.orange
    static let buttonBackground = Color(uiColor: .secondarySystemBackground)
    static let buttonOverlay = Color.orange
    static let buttonText = Color.primary
    static let textInputOverlay = Color.secondary
}

// MARK: - Strings

enum AppStrings {
    static let appTitle = "STORAGE LAB"
}
