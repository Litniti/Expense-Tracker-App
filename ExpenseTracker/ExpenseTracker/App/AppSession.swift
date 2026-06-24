import Combine
import SwiftUI

@MainActor
final class AppSession: ObservableObject {
    @Published private(set) var preferredColorScheme: ColorScheme?
    @Published private(set) var selectedCurrencyCode: String

    private var settingsService: SettingsServicing

    init(container: AppContainer) {
        self.settingsService = container.settingsService
        self.preferredColorScheme = container.settingsService.isDarkModeEnabled ? .dark : .light
        self.selectedCurrencyCode = container.settingsService.selectedCurrencyCode
    }

    func updateDarkMode(isEnabled: Bool) {
        settingsService.isDarkModeEnabled = isEnabled
        preferredColorScheme = isEnabled ? .dark : .light
    }

    func updateCurrency(code: String) {
        settingsService.selectedCurrencyCode = code
        selectedCurrencyCode = code
    }
}
