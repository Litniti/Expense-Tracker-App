import Combine
import SwiftUI

@MainActor
final class LocalizationManager: ObservableObject {
    static let storageKey = "app.selectedLanguage"

    @AppStorage(storageKey) var languageCode: String = AppLanguage.english.rawValue

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
                guard newValue != self.languageCode else { return }
                self.languageCode = newValue
                self.objectWillChange.send()
            }
        )
    }

    func setLanguage(_ language: AppLanguage) {
        guard language.rawValue != languageCode else { return }
        languageCode = language.rawValue
        objectWillChange.send()
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
