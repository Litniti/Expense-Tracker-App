import SwiftUI

struct PrimaryButton: View {
    let title: String
    let systemImage: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .font(AppTheme.Typography.body.weight(.semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppTheme.Colors.primaryGradient, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(.isButton)
    }
}
