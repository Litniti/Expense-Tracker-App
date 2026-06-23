import Foundation

final class UserDefaultsSettingsService: SettingsServicing {
    private enum Keys {
        static let darkMode = "settings.darkMode"
        static let currency = "settings.currency"
    }

    private let defaults: UserDefaults
    let monthlyBudget: Double

    init(defaults: UserDefaults = .standard, monthlyBudget: Double = 3_000) {
        self.defaults = defaults
        self.monthlyBudget = monthlyBudget
    }

    var isDarkModeEnabled: Bool {
        get { defaults.bool(forKey: Keys.darkMode) }
        set { defaults.set(newValue, forKey: Keys.darkMode) }
    }

    var selectedCurrencyCode: String {
        get { defaults.string(forKey: Keys.currency) ?? "USD" }
        set { defaults.set(newValue, forKey: Keys.currency) }
    }
}
