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

    func clearCharts() {
        state = .loading
        monthlySpending = []
        categorySpending = []
        trendSpending = []
    }

    func load(languageCode: String = AppLanguage.english.rawValue) {
        state = .loading
        let locale = Locale(identifier: languageCode)
        do {
            let expenses = try expenseService.fetchExpenses()
            monthlySpending = buildMonthlySeries(from: expenses, locale: locale)
            categorySpending = ExpenseCategory.allCases.compactMap { category in
                let total = expenses.filter { $0.category == category }.reduce(0) { $0 + $1.amount }
                return total > 0
                    ? AnalyticsPoint(
                        label: category.localizedName(languageCode: languageCode),
                        value: total,
                        seriesKey: category.rawValue
                    )
                    : nil
            }
            trendSpending = buildTrendSeries(from: expenses, locale: locale)
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private func buildMonthlySeries(from expenses: [Expense], locale: Locale) -> [AnalyticsPoint] {
        let grouped = Dictionary(grouping: expenses) {
            Calendar.current.dateInterval(of: .month, for: $0.date)?.start ?? $0.date
        }
        return grouped.keys.sorted().suffix(6).map { month in
            AnalyticsPoint(
                label: month.monthShort(locale: locale),
                value: grouped[month, default: []].reduce(0) { $0 + $1.amount }
            )
        }
    }

    private func buildTrendSeries(from expenses: [Expense], locale: Locale) -> [AnalyticsPoint] {
        expenses
            .sorted { $0.date < $1.date }
            .suffix(8)
            .map { AnalyticsPoint(label: $0.date.dayMonthShort(locale: locale), value: $0.amount) }
    }
}
