import SwiftUI

struct ExpenseCard: View {
    @Environment(\.locale) private var locale
    @EnvironmentObject private var localizationManager: LocalizationManager

    let expense: Expense
    let currencyCode: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                CategoryChip(category: expense.category)
                Spacer()
                Text(expense.amount.formattedCurrency(code: currencyCode, locale: locale))
                    .font(AppTheme.Typography.headline.weight(.bold))
                    .foregroundStyle(AppTheme.Colors.primaryText)
            }

            Text(expense.title)
                .font(AppTheme.Typography.headline)
                .foregroundStyle(AppTheme.Colors.primaryText)

            HStack {
                Label(expense.date.detailDateString(locale: locale), systemImage: "calendar")
                if !expense.notes.isEmpty {
                    Label("expense.has_notes", systemImage: "note.text")
                }
            }
            .font(AppTheme.Typography.caption)
            .foregroundStyle(AppTheme.Colors.secondaryText)

            if !expense.notes.isEmpty {
                Text(expense.notes)
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
                    .lineLimit(2)
            }
        }
        .padding()
        .cardStyle()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "\(expense.title), \(expense.amount.formattedCurrency(code: currencyCode, locale: locale)), \(localizationManager.localizedCategory(expense.category))"
        )
    }
}
