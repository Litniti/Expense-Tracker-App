import Foundation

@MainActor
final class MockExpenseService: ExpenseServicing {
    var expenses: [Expense]
    var shouldThrow = false

    init(expenses: [Expense] = []) {
        self.expenses = expenses
    }

    func fetchExpenses() throws -> [Expense] {
        try validate()
        return expenses.sorted { $0.date > $1.date }
    }

    func addExpense(from draft: ExpenseDraft) throws {
        try validate()
        expenses.append(
            Expense(
                title: draft.title,
                amount: draft.amount.doubleValue,
                category: draft.category,
                date: draft.date,
                notes: draft.notes
            )
        )
    }

    func updateExpense(_ expense: Expense, with draft: ExpenseDraft) throws {
        try validate()
        expense.title = draft.title
        expense.amount = draft.amount.doubleValue
        expense.category = draft.category
        expense.date = draft.date
        expense.notes = draft.notes
    }

    func deleteExpense(_ expense: Expense) throws {
        try validate()
        expenses.removeAll { $0.id == expense.id }
    }

    func resetAllData() throws {
        try validate()
        expenses.removeAll()
    }

    private func validate() throws {
        if shouldThrow {
            throw ExpenseServiceError.generic
        }
    }
}
