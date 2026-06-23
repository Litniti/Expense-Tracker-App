import Foundation

enum SampleData {
    static let previewExpenses: [Expense] = [
        Expense(title: "Groceries", amount: 62.40, category: .food, date: .now.addingTimeInterval(-86_400)),
        Expense(title: "Cinema", amount: 18.50, category: .entertainment, date: .now.addingTimeInterval(-172_800)),
        Expense(title: "Taxi", amount: 14.25, category: .transport, date: .now.addingTimeInterval(-240_000))
    ]
}
