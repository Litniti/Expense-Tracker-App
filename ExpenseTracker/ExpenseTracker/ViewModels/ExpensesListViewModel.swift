import Combine
import Foundation

@MainActor
final class ExpensesListViewModel: ObservableObject {
    @Published private(set) var state: ViewModelState = .idle
    @Published private(set) var expenses: [Expense] = []
    @Published var searchText = ""
    @Published var selectedCategory: ExpenseCategory?
    @Published var startDate: Date?
    @Published var endDate: Date?

    private let expenseService: ExpenseServicing

    init(expenseService: ExpenseServicing) {
        self.expenseService = expenseService
    }

    var filteredExpenses: [Expense] {
        expenses.filter { expense in
            let matchesSearch = searchText.isEmpty
                || expense.title.localizedCaseInsensitiveContains(searchText)
                || expense.notes.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory.map { expense.category == $0 } ?? true
            let matchesStart = startDate.map { expense.date >= $0 } ?? true
            let matchesEnd = endDate.map {
                Calendar.current.startOfDay(for: expense.date) <= Calendar.current.startOfDay(for: $0)
            } ?? true
            return matchesSearch && matchesCategory && matchesStart && matchesEnd
        }
    }

    func load() {
        state = .loading
        do {
            expenses = try expenseService.fetchExpenses()
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func delete(_ expense: Expense) {
        do {
            try expenseService.deleteExpense(expense)
            load()
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        startDate = nil
        endDate = nil
    }
}
