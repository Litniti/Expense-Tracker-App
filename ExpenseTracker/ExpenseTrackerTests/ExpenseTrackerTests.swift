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
        XCTAssertEqual(viewModel.validationMessageKey, "error.empty_title")

        viewModel.draft.title = "Coffee"
        viewModel.draft.amount = "0"

        XCTAssertFalse(viewModel.validate())
        XCTAssertEqual(viewModel.validationMessageKey, "error.zero_amount")
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

@MainActor
final class LocalizationTests: XCTestCase {
    func testEnglishLocalization() {
        XCTAssertEqual(ExpenseCategory.food.localizedName(languageCode: "en"), "Food")
        XCTAssertEqual(L10n.string("tab.dashboard", languageCode: "en"), "Dashboard")
    }

    func testFrenchLocalization() {
        XCTAssertEqual(ExpenseCategory.food.localizedName(languageCode: "fr"), "Alimentation")
        XCTAssertEqual(L10n.string("add_expense", languageCode: "fr"), "Ajouter une dépense")
    }

    func testArabicLocalization() {
        XCTAssertEqual(ExpenseCategory.transport.localizedName(languageCode: "ar"), "مواصلات")
        XCTAssertEqual(L10n.string("settings.language", languageCode: "ar"), "اللغة")
    }

    func testLocalizationManagerLanguage() async {
        let defaults = UserDefaults(suiteName: "LocalizationManagerTests")!
        defaults.removePersistentDomain(forName: "LocalizationManagerTests")

        let manager = LocalizationManager(userDefaults: defaults)

        manager.setLanguage(.english)
        let englishRTL = manager.isRTL
        XCTAssertFalse(englishRTL)

        manager.setLanguage(.arabic)
        let arabicRTL = manager.isRTL
        XCTAssertTrue(arabicRTL)
    }

    func testCurrencyFormattingUsesLocale() {
        let amount = 10.0
        let english = amount.formattedCurrency(code: "USD", locale: Locale(identifier: "en_US"))
        XCTAssertTrue(english.contains("10"))

        let french = amount.formattedCurrency(code: "EUR", locale: Locale(identifier: "fr_FR"))
        XCTAssertTrue(french.contains("10"))
    }

    func testLegacyCategoryMigration() {
        XCTAssertEqual(ExpenseCategory.fromStoredValue("Food"), .food)
        XCTAssertEqual(ExpenseCategory.fromStoredValue("food"), .food)
        XCTAssertEqual(ExpenseCategory.fromStoredValue("unknown"), .other)
    }
}
