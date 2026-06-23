import Combine
import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published private(set) var state: ViewModelState = .idle
    @Published private(set) var summary = DashboardSummary(
        monthSpending: 0,
        totalSpending: 0,
        budgetProgress: 0,
        remainingBudget: 0,
        recentExpenses: []
    )

    private let expenseService: ExpenseServicing
    private let monthlyBudget: Double

    init(expenseService: ExpenseServicing, monthlyBudget: Double = 3_000) {
        self.expenseService = expenseService
        self.monthlyBudget = monthlyBudget
    }

    func load() {
        state = .loading
        do {
            let expenses = try expenseService.fetchExpenses()
            let monthExpenses = expenses.filter { Calendar.current.isDate($0.date, equalTo: .now, toGranularity: .month) }
            let monthSpending = monthExpenses.reduce(0) { $0 + $1.amount }
            let totalSpending = expenses.reduce(0) { $0 + $1.amount }
            let progress = monthlyBudget == 0 ? 0 : min(monthSpending / monthlyBudget, 1)
            summary = DashboardSummary(
                monthSpending: monthSpending,
                totalSpending: totalSpending,
                budgetProgress: progress,
                remainingBudget: max(monthlyBudget - monthSpending, 0),
                recentExpenses: Array(expenses.prefix(5))
            )
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
