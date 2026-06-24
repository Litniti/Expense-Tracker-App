import Foundation

enum SampleData {
    static var mockExpenses: [Expense] {
        let calendar = Calendar.current
        let now = Date.now

        func daysAgo(_ days: Int) -> Date {
            calendar.date(byAdding: .day, value: -days, to: now) ?? now
        }

        func monthsAgo(_ months: Int, day: Int = 12) -> Date {
            var components = calendar.dateComponents([.year, .month], from: now)
            components.month = (components.month ?? 1) - months
            components.day = day
            return calendar.date(from: components) ?? now
        }

        return [
            Expense(title: "Weekly groceries", amount: 87.32, category: .food, date: daysAgo(1), notes: "Trader Joe's run"),
            Expense(title: "Morning coffee", amount: 5.75, category: .food, date: daysAgo(2)),
            Expense(title: "Uber to airport", amount: 34.50, category: .transport, date: daysAgo(3)),
            Expense(title: "Netflix", amount: 15.99, category: .entertainment, date: daysAgo(5), notes: "Monthly subscription"),
            Expense(title: "Pharmacy", amount: 22.40, category: .health, date: daysAgo(6)),
            Expense(title: "New sneakers", amount: 129.00, category: .shopping, date: daysAgo(8)),
            Expense(title: "Electric bill", amount: 94.20, category: .bills, date: daysAgo(10)),
            Expense(title: "Team lunch", amount: 42.80, category: .food, date: daysAgo(12)),
            Expense(title: "Gas refill", amount: 48.60, category: .transport, date: daysAgo(14)),
            Expense(title: "Concert tickets", amount: 75.00, category: .entertainment, date: daysAgo(18)),
            Expense(title: "Internet", amount: 59.99, category: .bills, date: monthsAgo(0, day: 1)),
            Expense(title: "Gym membership", amount: 39.00, category: .health, date: monthsAgo(0, day: 3)),
            Expense(title: "Birthday gift", amount: 65.00, category: .shopping, date: monthsAgo(1, day: 8)),
            Expense(title: "Restaurant dinner", amount: 112.50, category: .food, date: monthsAgo(1, day: 14)),
            Expense(title: "Train pass", amount: 89.00, category: .transport, date: monthsAgo(1, day: 20)),
            Expense(title: "Home supplies", amount: 54.30, category: .other, date: monthsAgo(2, day: 5)),
            Expense(title: "Streaming bundle", amount: 24.99, category: .entertainment, date: monthsAgo(2, day: 11)),
            Expense(title: "Dentist visit", amount: 120.00, category: .health, date: monthsAgo(2, day: 22)),
            Expense(title: "Rent utilities", amount: 145.00, category: .bills, date: monthsAgo(3, day: 2)),
            Expense(title: "Winter jacket", amount: 189.99, category: .shopping, date: monthsAgo(3, day: 16)),
            Expense(title: "Farmers market", amount: 38.45, category: .food, date: monthsAgo(4, day: 7)),
            Expense(title: "Car maintenance", amount: 210.00, category: .transport, date: monthsAgo(4, day: 19)),
            Expense(title: "Office supplies", amount: 31.20, category: .other, date: monthsAgo(5, day: 9)),
            Expense(title: "Holiday party", amount: 88.00, category: .entertainment, date: monthsAgo(5, day: 24)),
        ]
    }

    static var previewExpenses: [Expense] { mockExpenses }
}
