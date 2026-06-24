import SwiftUI

struct ExpenseFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizationManager: LocalizationManager
    @StateObject private var viewModel: ExpenseFormViewModel

    init(viewModel: ExpenseFormViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("expense_form.details") {
                    TextField("expense_form.title", text: $viewModel.draft.title)
                        .accessibilityLabel(Text("expense_form.title_accessibility"))

                    TextField("expense_form.amount", text: $viewModel.draft.amount)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel(Text("expense_form.amount_accessibility"))

                    Picker("expense_form.category", selection: $viewModel.draft.category) {
                        ForEach(ExpenseCategory.allCases) { category in
                            Label {
                                Text(localizationManager.localizedCategory(category))
                            } icon: {
                                Image(systemName: category.icon)
                            }
                            .tag(category)
                        }
                    }

                    DatePicker("expense_form.date", selection: $viewModel.draft.date, displayedComponents: .date)
                }

                Section("expense_form.notes") {
                    TextField("expense_form.notes_placeholder", text: $viewModel.draft.notes, axis: .vertical)
                        .lineLimit(4, reservesSpace: true)
                }

                if let errorMessage = viewModel.localizedValidationMessage(languageCode: localizationManager.languageCode) {
                    Section {
                        Text(errorMessage)
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(AppTheme.Colors.danger)
                    }
                }

                Section {
                    PrimaryButton(
                        title: localizationManager.localized(viewModel.mode.titleKey),
                        systemImage: "checkmark"
                    ) {
                        viewModel.save {
                            dismiss()
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .disabled(viewModel.isSaving)
                }
            }
            .navigationTitle(localizationManager.localized(viewModel.mode.titleKey))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("expense_form.cancel") { dismiss() }
                }
            }
        }
        .environment(\.locale, localizationManager.locale)
    }
}
