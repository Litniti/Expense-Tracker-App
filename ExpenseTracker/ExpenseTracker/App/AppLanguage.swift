import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case french = "fr"
    case arabic = "ar"

    var id: String { rawValue }

    var locale: Locale {
        Locale(identifier: rawValue)
    }

    /// Native display name — always shown in the language itself.
    var displayName: String {
        switch self {
        case .english: "English"
        case .french: "Français"
        case .arabic: "العربية"
        }
    }

    var isRTL: Bool {
        self == .arabic
    }

    static func from(code: String) -> AppLanguage {
        AppLanguage(rawValue: code) ?? .english
    }
}
