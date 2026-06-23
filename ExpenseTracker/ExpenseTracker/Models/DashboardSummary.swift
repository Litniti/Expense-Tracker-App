import Foundation

struct DashboardSummary: Equatable {
    let monthSpending: Double
    let totalSpending: Double
    let budgetProgress: Double
    let remainingBudget: Double
    let recentExpenses: [Expense]
}
