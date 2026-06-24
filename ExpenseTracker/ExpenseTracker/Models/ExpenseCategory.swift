import SwiftUI

enum ExpenseCategory: String, CaseIterable, Codable, Identifiable {
    case food
    case transport
    case shopping
    case entertainment
    case health
    case bills
    case other

    var id: String { rawValue }

    private static let legacyRawValues: [String: ExpenseCategory] = [
        "Food": .food,
        "Transport": .transport,
        "Shopping": .shopping,
        "Entertainment": .entertainment,
        "Health": .health,
        "Bills": .bills,
        "Other": .other
    ]

    static func fromStoredValue(_ value: String) -> ExpenseCategory {
        if let category = ExpenseCategory(rawValue: value) {
            return category
        }
        return legacyRawValues[value] ?? .other
    }

    func localizedName(languageCode: String) -> String {
        L10n.string("category.\(rawValue)", languageCode: languageCode)
    }

    var icon: String {
        switch self {
        case .food: "fork.knife"
        case .transport: "car.fill"
        case .shopping: "bag.fill"
        case .entertainment: "tv.fill"
        case .health: "cross.case.fill"
        case .bills: "doc.text.fill"
        case .other: "square.grid.2x2.fill"
        }
    }

    var color: Color {
        switch self {
        case .food: AppTheme.Colors.categoryFood
        case .transport: AppTheme.Colors.categoryTransport
        case .shopping: AppTheme.Colors.categoryShopping
        case .entertainment: AppTheme.Colors.categoryEntertainment
        case .health: AppTheme.Colors.categoryHealth
        case .bills: AppTheme.Colors.categoryBills
        case .other: AppTheme.Colors.categoryOther
        }
    }
}
