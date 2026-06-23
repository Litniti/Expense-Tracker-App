import SwiftUI

enum AppTheme {
    enum Colors {
        static let primary = Color(red: 0.03, green: 0.52, blue: 0.55)
        static let primaryDark = Color(red: 0.01, green: 0.23, blue: 0.28)
        static let success = Color(red: 0.13, green: 0.64, blue: 0.39)
        static let danger = Color(red: 0.84, green: 0.24, blue: 0.25)
        static let screenBackground = Color(red: 0.96, green: 0.98, blue: 0.99)
        static let cardBackground = Color.white.opacity(0.9)
        static let cardBorder = Color.black.opacity(0.08)
        static let primaryText = Color(red: 0.08, green: 0.12, blue: 0.17)
        static let secondaryText = Color(red: 0.39, green: 0.46, blue: 0.53)

        static let categoryFood = Color(red: 0.99, green: 0.58, blue: 0.17)
        static let categoryTransport = Color(red: 0.18, green: 0.50, blue: 0.96)
        static let categoryShopping = Color(red: 0.91, green: 0.33, blue: 0.53)
        static let categoryEntertainment = Color(red: 0.54, green: 0.35, blue: 0.97)
        static let categoryHealth = Color(red: 0.18, green: 0.69, blue: 0.64)
        static let categoryBills = Color(red: 0.93, green: 0.39, blue: 0.24)
        static let categoryOther = Color(red: 0.47, green: 0.52, blue: 0.57)

        static let primaryGradient = LinearGradient(
            colors: [primary, primaryDark],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    enum Typography {
        static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
        static let title = Font.system(.title2, design: .rounded, weight: .bold)
        static let headline = Font.system(.headline, design: .rounded)
        static let body = Font.system(.body, design: .rounded)
        static let caption = Font.system(.caption, design: .rounded)
    }

    enum Spacing {
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }

    enum CornerRadius {
        static let medium: CGFloat = 18
        static let large: CGFloat = 24
    }
}
