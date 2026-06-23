import Foundation

final class MockSettingsService: SettingsServicing {
    var isDarkModeEnabled: Bool
    var selectedCurrencyCode: String
    var monthlyBudget: Double

    init(isDarkModeEnabled: Bool = false, selectedCurrencyCode: String = "USD", monthlyBudget: Double = 3_000) {
        self.isDarkModeEnabled = isDarkModeEnabled
        self.selectedCurrencyCode = selectedCurrencyCode
        self.monthlyBudget = monthlyBudget
    }
}
