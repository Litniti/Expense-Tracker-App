import Foundation

struct ExpenseDraft: Equatable {
    var title = ""
    var amount = ""
    var category: ExpenseCategory = .food
    var date = Date()
    var notes = ""

    init() {}

    init(expense: Expense) {
        title = expense.title
        amount = expense.amount.currencyEditingValue(locale: .current)
        category = expense.category
        date = expense.date
        notes = expense.notes
    }
}
