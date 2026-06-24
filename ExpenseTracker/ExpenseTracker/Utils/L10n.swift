import Foundation

enum L10n {
    static func bundle(for languageCode: String) -> Bundle {
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return Bundle.main
        }
        return bundle
    }

    static func string(_ key: String, languageCode: String) -> String {
        let value = bundle(for: languageCode).localizedString(forKey: key, value: nil, table: nil)
        if value == key, languageCode != AppLanguage.english.rawValue {
            return bundle(for: AppLanguage.english.rawValue).localizedString(forKey: key, value: key, table: nil)
        }
        return value
    }

    static func formatted(_ key: String, languageCode: String, _ arguments: [CVarArg] = []) -> String {
        let format = string(key, languageCode: languageCode)
        guard !arguments.isEmpty else { return format }

        let locale = Locale(identifier: languageCode)
        return withVaList(arguments) { pointer in
            NSString(format: format, locale: locale, arguments: pointer) as String
        }
    }
}
