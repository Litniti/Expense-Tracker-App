import Foundation
import SwiftData

@Model
final class Expense {
    @Attribute(.unique) var id: UUID
    var title: String
    var amount: Double
    var categoryRawValue: String
    var date: Date
    var notes: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        category: ExpenseCategory,
        date: Date,
        notes: String = "",
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.categoryRawValue = category.rawValue
        self.date = date
        self.notes = notes
        self.createdAt = createdAt
    }

    var category: ExpenseCategory {
        get { ExpenseCategory(rawValue: categoryRawValue) ?? .other }
        set { categoryRawValue = newValue.rawValue }
    }
}
