import Combine
import Foundation

@MainActor
final class AnalyticsViewModel: ObservableObject {
    @Published private(set) var state: ViewModelState = .idle
    @Published private(set) var monthlySpending: [AnalyticsPoint] = []
    @Published private(set) var categorySpending: [AnalyticsPoint] = []
    @Published private(set) var trendSpending: [AnalyticsPoint] = []

    private let expenseService: ExpenseServicing

    init(expenseService: ExpenseServicing) {
        self.expenseService = expenseService
    }

    func load() {
        state = .loading
        do {
            let expenses = try expenseService.fetchExpenses()
            monthlySpending = buildMonthlySeries(from: expenses)
            categorySpending = ExpenseCategory.allCases.compactMap { category in
                let total = expenses.filter { $0.category == category }.reduce(0) { $0 + $1.amount }
                return total > 0 ? AnalyticsPoint(label: category.rawValue, value: total) : nil
            }
            trendSpending = buildTrendSeries(from: expenses)
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private func buildMonthlySeries(from expenses: [Expense]) -> [AnalyticsPoint] {
        let grouped = Dictionary(grouping: expenses) {
            Calendar.current.dateInterval(of: .month, for: $0.date)?.start ?? $0.date
        }
        return grouped.keys.sorted().suffix(6).map { month in
            AnalyticsPoint(
                label: month.monthShort,
                value: grouped[month, default: []].reduce(0) { $0 + $1.amount }
            )
        }
    }

    private func buildTrendSeries(from expenses: [Expense]) -> [AnalyticsPoint] {
        expenses
            .sorted { $0.date < $1.date }
            .suffix(8)
            .map { AnalyticsPoint(label: $0.date.dayMonthShort, value: $0.amount) }
    }
}
