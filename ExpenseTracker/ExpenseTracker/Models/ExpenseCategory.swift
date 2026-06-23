import SwiftUI

enum ExpenseCategory: String, CaseIterable, Codable, Identifiable {
    case food = "Food"
    case transport = "Transport"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case health = "Health"
    case bills = "Bills"
    case other = "Other"

    var id: String { rawValue }

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
