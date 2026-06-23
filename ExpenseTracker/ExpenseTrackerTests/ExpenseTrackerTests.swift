import XCTest
@testable import ExpenseTracker

@MainActor
final class ExpenseTrackerTests: XCTestCase {
    func testDashboardSummaryComputesMonthAndTotalSpend() {
        let service = MockExpenseService(expenses: [
            Expense(title: "Lunch", amount: 20, category: .food, date: .now),
            Expense(title: "Train", amount: 15, category: .transport, date: .now),
            Expense(title: "Old", amount: 30, category: .other, date: Calendar.current.date(byAdding: .month, value: -2, to: .now)!)
        ])
        let viewModel = DashboardViewModel(expenseService: service, monthlyBudget: 100)

        viewModel.load()

        XCTAssertEqual(viewModel.summary.monthSpending, 35, accuracy: 0.001)
        XCTAssertEqual(viewModel.summary.totalSpending, 65, accuracy: 0.001)
        XCTAssertEqual(viewModel.summary.budgetProgress, 0.35, accuracy: 0.001)
    }

    func testExpenseFormValidationRejectsEmptyTitleAndZeroAmount() {
        let viewModel = ExpenseFormViewModel(
            expenseService: MockExpenseService(),
            currencyCode: "USD",
            mode: .create
        )

        viewModel.draft.title = ""
        viewModel.draft.amount = "0"

        XCTAssertFalse(viewModel.validate())
        XCTAssertEqual(viewModel.errorMessage, "Add a title so you can recognize this expense later.")

        viewModel.draft.title = "Coffee"
        viewModel.draft.amount = "0"

        XCTAssertFalse(viewModel.validate())
        XCTAssertEqual(viewModel.errorMessage, "Enter an amount greater than zero.")
    }

    func testExpenseFilteringAppliesSearchCategoryAndDateRange() {
        let today = Date()
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        let service = MockExpenseService(expenses: [
            Expense(title: "Coffee Beans", amount: 12, category: .food, date: today),
            Expense(title: "Bus Card", amount: 30, category: .transport, date: weekAgo)
        ])
        let viewModel = ExpensesListViewModel(expenseService: service)

        viewModel.load()
        viewModel.searchText = "coffee"
        viewModel.selectedCategory = .food
        viewModel.startDate = Calendar.current.date(byAdding: .day, value: -1, to: today)
        viewModel.endDate = today

        XCTAssertEqual(viewModel.filteredExpenses.count, 1)
        XCTAssertEqual(viewModel.filteredExpenses.first?.title, "Coffee Beans")
    }
}
