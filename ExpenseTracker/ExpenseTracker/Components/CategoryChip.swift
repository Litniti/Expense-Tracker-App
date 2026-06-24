import SwiftUI

struct CategoryChip: View {
    @EnvironmentObject private var localizationManager: LocalizationManager

    let category: ExpenseCategory

    var body: some View {
        Label(localizationManager.localizedCategory(category), systemImage: category.icon)
            .font(AppTheme.Typography.caption.weight(.semibold))
            .foregroundStyle(category.color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(category.color.opacity(0.12), in: Capsule())
            .accessibilityElement(children: .combine)
    }
}
