import Foundation

enum ExpenseServiceError: LocalizedError {
    case generic

    func localizedDescription(languageCode: String) -> String {
        L10n.string("error.save_failed", languageCode: languageCode)
    }

    var errorDescription: String? {
        localizedDescription(languageCode: AppLanguage.english.rawValue)
    }
}
