import Combine
import Foundation

@MainActor
final class ExpenseFormViewModel: ObservableObject {
    enum Mode {
        case create
        case edit(Expense)

        var titleKey: String {
            switch self {
            case .create: "add_expense"
            case .edit: "edit_expense"
            }
        }
    }

    @Published var draft: ExpenseDraft
    @Published private(set) var validationMessageKey: String?
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
            validationMessageKey = "error.save_failed"
        }
    }

    @discardableResult
    func validate() -> Bool {
        let trimmedTitle = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            validationMessageKey = "error.empty_title"
            return false
        }
        guard draft.amount.doubleValue > 0 else {
            validationMessageKey = "error.zero_amount"
            return false
        }
        validationMessageKey = nil
        return true
    }

    func localizedValidationMessage(languageCode: String) -> String? {
        guard let validationMessageKey else { return nil }
        return L10n.string(validationMessageKey, languageCode: languageCode)
    }
}
