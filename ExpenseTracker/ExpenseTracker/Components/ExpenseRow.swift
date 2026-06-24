import SwiftUI

struct ExpenseRow: View {
    @Environment(\.locale) private var locale
    @EnvironmentObject private var localizationManager: LocalizationManager

    let expense: Expense
    let currencyCode: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(expense.category.color.opacity(0.16))
                    .frame(width: 44, height: 44)
                Image(systemName: expense.category.icon)
                    .foregroundStyle(expense.category.color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(AppTheme.Typography.body.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.primaryText)
                Text("\(localizationManager.localizedCategory(expense.category)) • \(expense.date.detailDateString(locale: locale))")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
            }

            Spacer()

            Text(expense.amount.formattedCurrency(code: currencyCode, locale: locale))
                .font(AppTheme.Typography.body.weight(.bold))
                .foregroundStyle(AppTheme.Colors.primaryText)
        }
        .padding()
        .background(AppTheme.Colors.cardBackground, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
    }
}
