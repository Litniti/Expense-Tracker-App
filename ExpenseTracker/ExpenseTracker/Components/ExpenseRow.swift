import SwiftUI

struct ExpenseRow: View {
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
                Text("\(expense.category.rawValue) • \(expense.date.detailDateString)")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
            }

            Spacer()

            Text(expense.amount.formattedCurrency(code: currencyCode))
                .font(AppTheme.Typography.body.weight(.bold))
                .foregroundStyle(AppTheme.Colors.primaryText)
        }
        .padding()
        .background(AppTheme.Colors.cardBackground, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
    }
}
