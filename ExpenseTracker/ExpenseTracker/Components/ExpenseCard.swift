import SwiftUI

struct ExpenseCard: View {
    let expense: Expense
    let currencyCode: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                CategoryChip(category: expense.category)
                Spacer()
                Text(expense.amount.formattedCurrency(code: currencyCode))
                    .font(AppTheme.Typography.headline.weight(.bold))
                    .foregroundStyle(AppTheme.Colors.primaryText)
            }

            Text(expense.title)
                .font(AppTheme.Typography.headline)
                .foregroundStyle(AppTheme.Colors.primaryText)

            HStack {
                Label(expense.date.detailDateString, systemImage: "calendar")
                if !expense.notes.isEmpty {
                    Label("Has notes", systemImage: "note.text")
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
        .accessibilityLabel("\(expense.title), \(expense.amount.formattedCurrency(code: currencyCode)), \(expense.category.rawValue)")
    }
}
