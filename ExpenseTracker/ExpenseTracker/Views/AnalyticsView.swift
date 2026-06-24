import Charts
import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    @StateObject private var viewModel: AnalyticsViewModel

    init(viewModel: AnalyticsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.large) {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("analytics.loading")
                        .frame(maxWidth: .infinity, minHeight: 300)
                case let .error(message):
                    EmptyStateView(
                        title: "analytics.unavailable",
                        message: LocalizedStringKey(message),
                        systemImage: "chart.bar.xaxis"
                    )
                case .loaded:
                    if viewModel.monthlySpending.isEmpty {
                        EmptyStateView(
                            title: "analytics.empty.title",
                            message: "analytics.empty.message",
                            systemImage: "chart.pie"
                        )
                    } else {
                        chartsContent
                    }
                }
            }
            .padding()
        }
        .background(AppTheme.Colors.screenBackground.ignoresSafeArea())
        .navigationTitle("analytics.title")
        .task { viewModel.load(languageCode: localizationManager.languageCode) }
        .onChange(of: localizationManager.languageCode) { _, newCode in
            viewModel.clearCharts()
            Task { @MainActor in
                await Task.yield()
                viewModel.load(languageCode: newCode)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .expensesDidChange)) { _ in
            viewModel.load(languageCode: localizationManager.languageCode)
        }
    }

    private var chartsContent: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            monthlyChart
            categoryChart
            trendChart
        }
        .id(localizationManager.languageCode)
    }

    private var monthlyChart: some View {
        ChartCard(title: "analytics.chart.monthly.title", subtitle: "analytics.chart.monthly.subtitle") {
            Chart(viewModel.monthlySpending) { point in
                BarMark(
                    x: .value(ChartDimension.month, point.label),
                    y: .value(ChartDimension.amount, point.value)
                )
                .foregroundStyle(AppTheme.Colors.primaryGradient)
                .cornerRadius(8)
            }
            .frame(height: 220)
        }
    }

    private var categoryChart: some View {
        ChartCard(title: "analytics.chart.category.title", subtitle: "analytics.chart.category.subtitle") {
            Chart(viewModel.categorySpending) { point in
                SectorMark(
                    angle: .value(ChartDimension.amount, point.value),
                    innerRadius: .ratio(0.6)
                )
                .foregroundStyle(by: .value(ChartDimension.category, point.seriesKey ?? point.label))
            }
            .chartForegroundStyleScale(
                domain: ExpenseCategory.allCases.map(\.rawValue),
                range: ExpenseCategory.allCases.map(\.color)
            )
            .frame(height: 260)
        }
    }

    private var trendChart: some View {
        ChartCard(title: "analytics.chart.trend.title", subtitle: "analytics.chart.trend.subtitle") {
            Chart(viewModel.trendSpending) { point in
                LineMark(
                    x: .value(ChartDimension.day, point.label),
                    y: .value(ChartDimension.amount, point.value)
                )
                .foregroundStyle(AppTheme.Colors.success)
                .lineStyle(.init(lineWidth: 3, lineCap: .round))
                AreaMark(
                    x: .value(ChartDimension.day, point.label),
                    y: .value(ChartDimension.amount, point.value)
                )
                .foregroundStyle(AppTheme.Colors.success.opacity(0.18))
            }
            .frame(height: 220)
        }
    }
}

private struct ChartCard<Content: View>: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let content: Content

    init(title: LocalizedStringKey, subtitle: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppTheme.Typography.headline)
                .foregroundStyle(AppTheme.Colors.primaryText)
            Text(subtitle)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.secondaryText)
            content
        }
        .padding()
        .cardStyle()
    }
}
