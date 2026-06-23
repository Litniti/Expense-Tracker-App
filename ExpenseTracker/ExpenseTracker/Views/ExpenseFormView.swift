import SwiftUI

struct ExpenseFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ExpenseFormViewModel

    init(viewModel: ExpenseFormViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $viewModel.draft.title)
                        .accessibilityLabel("Expense title")

                    TextField("Amount", text: $viewModel.draft.amount)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Expense amount")

                    Picker("Category", selection: $viewModel.draft.category) {
                        ForEach(ExpenseCategory.allCases) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }

                    DatePicker("Date", selection: $viewModel.draft.date, displayedComponents: .date)
                }

                Section("Notes") {
                    TextField("Optional notes", text: $viewModel.draft.notes, axis: .vertical)
                        .lineLimit(4, reservesSpace: true)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(AppTheme.Colors.danger)
                    }
                }

                Section {
                    PrimaryButton(title: viewModel.mode.title, systemImage: "checkmark") {
                        viewModel.save {
                            dismiss()
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .disabled(viewModel.isSaving)
                }
            }
            .navigationTitle(viewModel.mode.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
