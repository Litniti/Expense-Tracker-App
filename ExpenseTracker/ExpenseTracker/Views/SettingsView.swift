import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appSession: AppSession
    @EnvironmentObject private var localizationManager: LocalizationManager
    @StateObject private var viewModel: SettingsViewModel
    @State private var isShowingResetConfirmation = false

    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            Section("settings.appearance") {
                Toggle("settings.dark_mode", isOn: $viewModel.isDarkModeEnabled)
                    .onChange(of: viewModel.isDarkModeEnabled) { _, _ in
                        viewModel.updateDarkMode()
                        appSession.updateDarkMode(isEnabled: viewModel.isDarkModeEnabled)
                    }
            }

            Section("settings.language") {
                Picker("settings.language", selection: localizationManager.languageSelection) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(language.displayName).tag(language.rawValue)
                    }
                }
            }

            Section("settings.currency") {
                Picker("settings.currency", selection: $viewModel.selectedCurrencyCode) {
                    ForEach(viewModel.availableCurrencies, id: \.self) { code in
                        Text(code).tag(code)
                    }
                }
                .onChange(of: viewModel.selectedCurrencyCode) { _, _ in
                    viewModel.updateCurrency()
                    appSession.updateCurrency(code: viewModel.selectedCurrencyCode)
                }
            }

            Section("settings.data") {
                Button("settings.reset_button", role: .destructive) {
                    isShowingResetConfirmation = true
                }
            }

            if case let .error(message) = viewModel.state {
                Section {
                    Text(message)
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(AppTheme.Colors.danger)
                }
            }
        }
        .navigationTitle("settings.title")
        .alert("settings.reset.title", isPresented: $isShowingResetConfirmation) {
            Button("settings.reset.confirm", role: .destructive) {
                viewModel.resetData()
            }
            Button("expense_form.cancel", role: .cancel) { }
        } message: {
            Text("settings.reset.message")
        }
    }
}
