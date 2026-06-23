import Foundation

protocol SettingsServicing {
    var isDarkModeEnabled: Bool { get set }
    var selectedCurrencyCode: String { get set }
    var monthlyBudget: Double { get }
}
