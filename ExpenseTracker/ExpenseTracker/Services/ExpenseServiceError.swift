import Foundation

enum ExpenseServiceError: LocalizedError {
    case generic

    var errorDescription: String? {
        "Something went wrong while saving your expenses. Please try again."
    }
}
