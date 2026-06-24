import SwiftUI

struct SummaryCard: View {
    let title: String
    let value: String
    let subtitle: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(AppTheme.Typography.caption.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Text(value)
                .font(AppTheme.Typography.title)
                .foregroundStyle(AppTheme.Colors.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(subtitle)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(accent)
        }
        .padding()
        .cardStyle()
        .accessibilityElement(children: .combine)
    }
}
