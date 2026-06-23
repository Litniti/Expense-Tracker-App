import Charts
import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject private var appSession: AppSession
    @StateObject private var viewModel: AnalyticsViewModel

    init(viewModel: AnalyticsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.large) {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading analytics…")
                        .frame(maxWidth: .infinity, minHeight: 300)
                case let .error(message):
                    EmptyStateView(title: "Analytics unavailable", message: message, systemImage: "chart.bar.xaxis")
                case .loaded:
                    if viewModel.monthlySpending.isEmpty {
                        EmptyStateView(
                            title: "No analytics yet",
                            message: "Add expenses to see monthly patterns, category splits, and spending trends.",
                            systemImage: "chart.pie"
                        )
                    } else {
                        monthlyChart
                        categoryChart
                        trendChart
                    }
                }
            }
            .padding()
        }
        .background(AppTheme.Colors.screenBackground.ignoresSafeArea())
        .navigationTitle("Analytics")
        .task { viewModel.load() }
        .onReceive(NotificationCenter.default.publisher(for: .expensesDidChange)) { _ in
            viewModel.load()
        }
    }

    private var monthlyChart: some View {
        ChartCard(title: "Monthly Spending", subtitle: "Your spending over the last six months") {
            Chart(viewModel.monthlySpending) { point in
                BarMark(x: .value("Month", point.label), y: .value("Amount", point.value))
                    .foregroundStyle(AppTheme.Colors.primaryGradient)
                    .cornerRadius(8)
            }
            .frame(height: 220)
        }
    }

    private var categoryChart: some View {
        ChartCard(title: "By Category", subtitle: "Where your money goes most often") {
            Chart(viewModel.categorySpending) { point in
                SectorMark(angle: .value("Amount", point.value), innerRadius: .ratio(0.6))
                    .foregroundStyle(by: .value("Category", point.label))
            }
            .chartForegroundStyleScale(
                domain: ExpenseCategory.allCases.map(\.rawValue),
                range: ExpenseCategory.allCases.map(\.color)
            )
            .frame(height: 260)
        }
    }

    private var trendChart: some View {
        ChartCard(title: "Recent Trend", subtitle: "The latest spending points on your timeline") {
            Chart(viewModel.trendSpending) { point in
                LineMark(x: .value("Day", point.label), y: .value("Amount", point.value))
                    .foregroundStyle(AppTheme.Colors.success)
                    .lineStyle(.init(lineWidth: 3, lineCap: .round))
                AreaMark(x: .value("Day", point.label), y: .value("Amount", point.value))
                    .foregroundStyle(AppTheme.Colors.success.opacity(0.18))
            }
            .frame(height: 220)
        }
    }
}

private struct ChartCard<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
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
