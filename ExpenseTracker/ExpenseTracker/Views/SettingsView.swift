import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appSession: AppSession
    @StateObject private var viewModel: SettingsViewModel
    @State private var isShowingResetConfirmation = false

    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $viewModel.isDarkModeEnabled)
                    .onChange(of: viewModel.isDarkModeEnabled) { _, _ in
                        viewModel.updateDarkMode()
                        appSession.updateDarkMode(isEnabled: viewModel.isDarkModeEnabled)
                    }
            }

            Section("Currency") {
                Picker("Currency", selection: $viewModel.selectedCurrencyCode) {
                    ForEach(viewModel.availableCurrencies, id: \.self) { code in
                        Text(code).tag(code)
                    }
                }
                .onChange(of: viewModel.selectedCurrencyCode) { _, _ in
                    viewModel.updateCurrency()
                    appSession.updateCurrency(code: viewModel.selectedCurrencyCode)
                }
            }

            Section("Data") {
                Button("Reset all expense data", role: .destructive) {
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
        .navigationTitle("Settings")
        .confirmationDialog("Reset all data?", isPresented: $isShowingResetConfirmation) {
            Button("Reset", role: .destructive) {
                viewModel.resetData()
            }
        } message: {
            Text("This removes every saved expense and cannot be undone.")
        }
    }
}
