import Foundation
import SwiftData

@MainActor
struct SwiftDataExpenseService: ExpenseServicing {
    let modelContainer: ModelContainer

    func fetchExpenses() throws -> [Expense] {
        let descriptor = FetchDescriptor<Expense>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try modelContainer.mainContext.fetch(descriptor)
    }

    func addExpense(from draft: ExpenseDraft) throws {
        let expense = Expense(
            title: draft.title.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: draft.amount.doubleValue,
            category: draft.category,
            date: draft.date,
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        modelContainer.mainContext.insert(expense)
        try modelContainer.mainContext.save()
        NotificationCenter.default.post(name: .expensesDidChange, object: nil)
    }

    func updateExpense(_ expense: Expense, with draft: ExpenseDraft) throws {
        expense.title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        expense.amount = draft.amount.doubleValue
        expense.category = draft.category
        expense.date = draft.date
        expense.notes = draft.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        try modelContainer.mainContext.save()
        NotificationCenter.default.post(name: .expensesDidChange, object: nil)
    }

    func deleteExpense(_ expense: Expense) throws {
        modelContainer.mainContext.delete(expense)
        try modelContainer.mainContext.save()
        NotificationCenter.default.post(name: .expensesDidChange, object: nil)
    }

    func resetAllData() throws {
        let expenses = try fetchExpenses()
        for expense in expenses {
            modelContainer.mainContext.delete(expense)
        }
        try modelContainer.mainContext.save()
        NotificationCenter.default.post(name: .expensesDidChange, object: nil)
    }
}
