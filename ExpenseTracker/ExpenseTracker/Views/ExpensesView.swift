import SwiftUI

struct ExpensesView: View {
    @EnvironmentObject private var appSession: AppSession
    @StateObject private var viewModel: ExpensesListViewModel
    let formFactory: () -> ExpenseFormViewModel
    let editFactory: (Expense) -> ExpenseFormViewModel

    @State private var isPresentingForm = false
    @State private var selectedExpense: Expense?

    init(
        viewModel: ExpensesListViewModel,
        formFactory: @escaping () -> ExpenseFormViewModel,
        editFactory: @escaping (Expense) -> ExpenseFormViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.formFactory = formFactory
        self.editFactory = editFactory
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Loading expenses…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case let .error(message):
                EmptyStateView(title: "Couldn’t load expenses", message: message, systemImage: "tray.full")
                    .padding()
            case .loaded:
                content
            }
        }
        .background(AppTheme.Colors.screenBackground.ignoresSafeArea())
        .navigationTitle("Expenses")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    selectedExpense = nil
                    isPresentingForm = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .accessibilityLabel("Add expense")
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search expenses")
        .sheet(isPresented: $isPresentingForm) {
            ExpenseFormView(viewModel: formFactory())
        }
        .sheet(item: $selectedExpense) { expense in
            ExpenseFormView(viewModel: editFactory(expense))
        }
        .task { viewModel.load() }
        .onReceive(NotificationCenter.default.publisher(for: .expensesDidChange)) { _ in
            viewModel.load()
        }
    }

    private var content: some View {
        List {
            filterSection

            if viewModel.filteredExpenses.isEmpty {
                EmptyStateView(
                    title: "No matching expenses",
                    message: "Try adjusting your search, category, or date filters.",
                    systemImage: "magnifyingglass"
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            } else {
                ForEach(viewModel.filteredExpenses) { expense in
                    ExpenseRow(expense: expense, currencyCode: appSession.selectedCurrencyCode)
                        .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.delete(expense)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                selectedExpense = expense
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(AppTheme.Colors.primary)
                        }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var filterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(title: "All", isSelected: viewModel.selectedCategory == nil) {
                        viewModel.selectedCategory = nil
                    }
                    ForEach(ExpenseCategory.allCases) { category in
                        FilterChip(title: category.rawValue, isSelected: viewModel.selectedCategory == category) {
                            viewModel.selectedCategory = category
                        }
                    }
                }
            }

            HStack(spacing: 12) {
                DatePicker("From", selection: binding(for: \.startDate), displayedComponents: .date)
                DatePicker("To", selection: binding(for: \.endDate), displayedComponents: .date)
            }
            .font(AppTheme.Typography.caption)

            if viewModel.selectedCategory != nil || viewModel.startDate != nil || viewModel.endDate != nil {
                Button("Clear filters") {
                    viewModel.clearFilters()
                }
                .font(AppTheme.Typography.caption.weight(.semibold))
            }
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }

    private func binding(for keyPath: ReferenceWritableKeyPath<ExpensesListViewModel, Date?>) -> Binding<Date> {
        Binding {
            viewModel[keyPath: keyPath] ?? .now
        } set: { value in
            viewModel[keyPath: keyPath] = value
        }
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.caption.weight(.semibold))
                .foregroundStyle(isSelected ? .white : AppTheme.Colors.secondaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    isSelected ? AnyShapeStyle(AppTheme.Colors.primaryGradient) : AnyShapeStyle(AppTheme.Colors.cardBackground),
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
    }
}
