import SwiftUI

struct RootTabView: View {
    let container: AppContainer

    var body: some View {
        TabView {
            NavigationStack {
                DashboardView(
                    viewModel: DashboardViewModel(
                        expenseService: container.expenseService,
                        monthlyBudget: container.settingsService.monthlyBudget
                    )
                )
            }
            .tabItem {
                Label("tab.dashboard", systemImage: "house.fill")
            }

            NavigationStack {
                ExpensesView(
                    viewModel: ExpensesListViewModel(expenseService: container.expenseService),
                    formFactory: {
                        ExpenseFormViewModel(
                            expenseService: container.expenseService,
                            currencyCode: container.settingsService.selectedCurrencyCode,
                            mode: .create
                        )
                    },
                    editFactory: { expense in
                        ExpenseFormViewModel(
                            expenseService: container.expenseService,
                            currencyCode: container.settingsService.selectedCurrencyCode,
                            mode: .edit(expense)
                        )
                    }
                )
            }
            .tabItem {
                Label("tab.expenses", systemImage: "list.bullet.rectangle.fill")
            }

            NavigationStack {
                AnalyticsView(viewModel: AnalyticsViewModel(expenseService: container.expenseService))
            }
            .tabItem {
                Label("tab.analytics", systemImage: "chart.xyaxis.line")
            }

            NavigationStack {
                SettingsView(
                    viewModel: SettingsViewModel(
                        expenseService: container.expenseService,
                        settingsService: container.settingsService
                    )
                )
            }
            .tabItem {
                Label("tab.settings", systemImage: "gearshape.fill")
            }
        }
        .tint(AppTheme.Colors.primary)
    }
}
