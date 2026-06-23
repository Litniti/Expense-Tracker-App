import SwiftUI

struct CategoryChip: View {
    let category: ExpenseCategory

    var body: some View {
        Label(category.rawValue, systemImage: category.icon)
            .font(AppTheme.Typography.caption.weight(.semibold))
            .foregroundStyle(category.color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(category.color.opacity(0.12), in: Capsule())
            .accessibilityElement(children: .combine)
    }
}
