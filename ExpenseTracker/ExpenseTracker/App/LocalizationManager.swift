import Combine
import SwiftUI

@MainActor
final class LocalizationManager: ObservableObject {
    static let storageKey = "app.selectedLanguage"

    private let userDefaults: UserDefaults

    @Published private(set) var languageCode: String

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.languageCode = userDefaults.string(forKey: Self.storageKey)
            ?? AppLanguage.english.rawValue
    }

    var currentLanguage: AppLanguage {
        AppLanguage.from(code: languageCode)
    }

    var locale: Locale {
        currentLanguage.locale
    }

    var isRTL: Bool {
        currentLanguage.isRTL
    }

    var languageSelection: Binding<String> {
        Binding(
            get: { self.languageCode },
            set: { newValue in
                self.setLanguage(AppLanguage.from(code: newValue)) }
        )
    }

    func setLanguage(_ language: AppLanguage) {
        guard language.rawValue != languageCode else { return }

        languageCode = language.rawValue
        userDefaults.set(language.rawValue, forKey: Self.storageKey)
    }

    func localized(_ key: String) -> String {
        L10n.string(key, languageCode: languageCode)
    }

    func localized(_ key: String, _ arguments: CVarArg...) -> String {
        L10n.formatted(key, languageCode: languageCode, Array(arguments))
    }

    func localizedCategory(_ category: ExpenseCategory) -> String {
        localized("category.\(category.rawValue)")
    }
}
