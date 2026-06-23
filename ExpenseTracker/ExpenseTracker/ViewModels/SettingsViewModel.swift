import Combine
import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var isDarkModeEnabled: Bool
    @Published var selectedCurrencyCode: String
    @Published var state: ViewModelState = .idle

    let availableCurrencies = ["USD", "EUR", "GBP", "MAD", "JPY"]

    private let expenseService: ExpenseServicing
    private var settingsService: SettingsServicing

    init(expenseService: ExpenseServicing, settingsService: SettingsServicing) {
        self.expenseService = expenseService
        self.settingsService = settingsService
        self.isDarkModeEnabled = settingsService.isDarkModeEnabled
        self.selectedCurrencyCode = settingsService.selectedCurrencyCode
    }

    func updateDarkMode() {
        settingsService.isDarkModeEnabled = isDarkModeEnabled
    }

    func updateCurrency() {
        settingsService.selectedCurrencyCode = selectedCurrencyCode
    }

    func resetData() {
        do {
            try expenseService.resetAllData()
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
