import Charts
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var appSession: AppSession
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.locale) private var locale
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
        .navigationTitle("dashboard.title")
        .task { viewModel.load() }
        .onReceive(NotificationCenter.default.publisher(for: .expensesDidChange)) { _ in
            viewModel.load()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("dashboard.tagline.title")
                .font(AppTheme.Typography.largeTitle)
                .foregroundStyle(AppTheme.Colors.primaryText)
            Text("dashboard.tagline.subtitle")
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.secondaryText)
        }
    }

    @ViewBuilder
    private var stateView: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("dashboard.loading")
                .frame(maxWidth: .infinity, minHeight: 220)
        case let .error(message):
            EmptyStateView(
                title: "dashboard.unavailable",
                message: LocalizedStringKey(message),
                systemImage: "exclamationmark.triangle"
            )
        case .loaded:
            VStack(spacing: AppTheme.Spacing.large) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppTheme.Spacing.medium) {
                    SummaryCard(
                        title: localizationManager.localized("dashboard.summary.this_month"),
                        value: viewModel.summary.monthSpending.formattedCurrency(
                            code: appSession.selectedCurrencyCode,
                            locale: locale
                        ),
                        subtitle: localizationManager.localized(
                            "dashboard.summary.budget_used",
                            Int(viewModel.summary.budgetProgress * 100)
                        ),
                        accent: AppTheme.Colors.primary
                    )
                    SummaryCard(
                        title: localizationManager.localized("dashboard.summary.total_spent"),
                        value: viewModel.summary.totalSpending.formattedCurrency(
                            code: appSession.selectedCurrencyCode,
                            locale: locale
                        ),
                        subtitle: localizationManager.localized(
                            "dashboard.summary.recent_expenses_count",
                            viewModel.summary.recentExpenses.count
                        ),
                        accent: AppTheme.Colors.success
                    )
                }

                budgetCard

                if viewModel.summary.recentExpenses.isEmpty {
                    EmptyStateView(
                        title: "dashboard.empty.title",
                        message: "dashboard.empty.message",
                        systemImage: "creditcard"
                    )
                } else {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                        Text("dashboard.recent_expenses")
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
                Text("dashboard.budget_progress")
                    .font(AppTheme.Typography.headline)
                Spacer()
                Text(
                    localizationManager.localized(
                        "dashboard.budget_left",
                        viewModel.summary.remainingBudget.formattedCurrency(
                            code: appSession.selectedCurrencyCode,
                            locale: locale
                        )
                    )
                )
                .font(AppTheme.Typography.caption.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.secondaryText)
            }

            Chart {
                SectorMark(
                    angle: .value(ChartDimension.spent, viewModel.summary.budgetProgress),
                    innerRadius: .ratio(0.65),
                    angularInset: 2
                )
                .foregroundStyle(AppTheme.Colors.primary)

                SectorMark(
                    angle: .value(
                        ChartDimension.remaining,
                        max(1 - viewModel.summary.budgetProgress, 0)
                    ),
                    innerRadius: .ratio(0.65),
                    angularInset: 2
                )
                .foregroundStyle(AppTheme.Colors.cardBorder)
            }
            .id(localizationManager.languageCode)
            .frame(height: 180)
        }
        .padding()
        .cardStyle()
    }
}
