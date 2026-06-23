import Combine
import Foundation

@MainActor
final class ExpenseFormViewModel: ObservableObject {
    enum Mode {
        case create
        case edit(Expense)

        var title: String {
            switch self {
            case .create: "Add Expense"
            case .edit: "Edit Expense"
            }
        }
    }

    @Published var draft: ExpenseDraft
    @Published var errorMessage: String?
    @Published var isSaving = false

    let mode: Mode
    let currencyCode: String

    private let expenseService: ExpenseServicing

    init(expenseService: ExpenseServicing, currencyCode: String, mode: Mode) {
        self.expenseService = expenseService
        self.currencyCode = currencyCode
        self.mode = mode
        switch mode {
        case .create:
            self.draft = ExpenseDraft()
        case let .edit(expense):
            self.draft = ExpenseDraft(expense: expense)
        }
    }

    func save(onSuccess: () -> Void) {
        guard validate() else { return }

        isSaving = true
        defer { isSaving = false }

        do {
            switch mode {
            case .create:
                try expenseService.addExpense(from: draft)
            case let .edit(expense):
                try expenseService.updateExpense(expense, with: draft)
            }
            onSuccess()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @discardableResult
    func validate() -> Bool {
        let trimmedTitle = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            errorMessage = "Add a title so you can recognize this expense later."
            return false
        }
        guard draft.amount.doubleValue > 0 else {
            errorMessage = "Enter an amount greater than zero."
            return false
        }
        errorMessage = nil
        return true
    }
}
