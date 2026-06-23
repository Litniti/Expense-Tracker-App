import Foundation

@MainActor
protocol ExpenseServicing {
    func fetchExpenses() throws -> [Expense]
    func addExpense(from draft: ExpenseDraft) throws
    func updateExpense(_ expense: Expense, with draft: ExpenseDraft) throws
    func deleteExpense(_ expense: Expense) throws
    func resetAllData() throws
}
