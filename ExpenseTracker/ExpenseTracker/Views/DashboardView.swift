import Charts
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var appSession: AppSession
    @StateObject private var viewModel: DashboardViewModel

    init(viewModel: DashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                header
                stateView
            }
            .padding()
        }
        .background(AppTheme.Colors.screenBackground.ignoresSafeArea())
        .navigationTitle("Dashboard")
        .task { viewModel.load() }
        .onReceive(NotificationCenter.default.publisher(for: .expensesDidChange)) { _ in
            viewModel.load()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Spend smarter")
                .font(AppTheme.Typography.largeTitle)
                .foregroundStyle(AppTheme.Colors.primaryText)
            Text("A calm overview of your money this month.")
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.secondaryText)
        }
    }

    @ViewBuilder
    private var stateView: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading dashboard…")
                .frame(maxWidth: .infinity, minHeight: 220)
        case let .error(message):
            EmptyStateView(title: "Dashboard unavailable", message: message, systemImage: "exclamationmark.triangle")
        case .loaded:
            VStack(spacing: AppTheme.Spacing.large) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppTheme.Spacing.medium) {
                    SummaryCard(
                        title: "This Month",
                        value: viewModel.summary.monthSpending.formattedCurrency(code: appSession.selectedCurrencyCode),
                        subtitle: "\(Int(viewModel.summary.budgetProgress * 100))% of budget used",
                        accent: AppTheme.Colors.primary
                    )
                    SummaryCard(
                        title: "Total Spent",
                        value: viewModel.summary.totalSpending.formattedCurrency(code: appSession.selectedCurrencyCode),
                        subtitle: "\(viewModel.summary.recentExpenses.count) recent expenses",
                        accent: AppTheme.Colors.success
                    )
                }

                budgetCard

                if viewModel.summary.recentExpenses.isEmpty {
                    EmptyStateView(
                        title: "No expenses yet",
                        message: "Add your first expense to unlock analytics, budget tracking, and monthly insights.",
                        systemImage: "creditcard"
                    )
                } else {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                        Text("Recent Expenses")
                            .font(AppTheme.Typography.headline)
                            .foregroundStyle(AppTheme.Colors.primaryText)

                        ForEach(viewModel.summary.recentExpenses) { expense in
                            ExpenseCard(expense: expense, currencyCode: appSession.selectedCurrencyCode)
                        }
                    }
                }
            }
        }
    }

    private var budgetCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Budget Progress")
                    .font(AppTheme.Typography.headline)
                Spacer()
                Text(viewModel.summary.remainingBudget.formattedCurrency(code: appSession.selectedCurrencyCode) + " left")
                    .font(AppTheme.Typography.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.secondaryText)
            }

            Chart {
                SectorMark(
                    angle: .value("Spent", viewModel.summary.budgetProgress),
                    innerRadius: .ratio(0.65),
                    angularInset: 2
                )
                .foregroundStyle(AppTheme.Colors.primary)

                SectorMark(
                    angle: .value("Remaining", max(1 - viewModel.summary.budgetProgress, 0)),
                    innerRadius: .ratio(0.65),
                    angularInset: 2
                )
                .foregroundStyle(AppTheme.Colors.cardBorder)
            }
            .frame(height: 180)
        }
        .padding()
        .cardStyle()
    }
}
