import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum AppTheme {
    enum Colors {
        private static func adaptive(light: Color, dark: Color) -> Color {
            #if canImport(UIKit)
            Color(uiColor: UIColor { traits in
                traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
            })
            #else
            light
            #endif
        }

        private static func adaptiveRGB(
            light: (CGFloat, CGFloat, CGFloat),
            dark: (CGFloat, CGFloat, CGFloat),
            lightOpacity: CGFloat = 1,
            darkOpacity: CGFloat = 1
        ) -> Color {
            adaptive(
                light: Color(red: light.0, green: light.1, blue: light.2).opacity(lightOpacity),
                dark: Color(red: dark.0, green: dark.1, blue: dark.2).opacity(darkOpacity)
            )
        }

        static let primary = Color(red: 0.03, green: 0.52, blue: 0.55)
        static let primaryDark = Color(red: 0.01, green: 0.23, blue: 0.28)
        static let success = Color(red: 0.13, green: 0.64, blue: 0.39)
        static let danger = Color(red: 0.84, green: 0.24, blue: 0.25)

        static let screenBackground = adaptiveRGB(
            light: (0.96, 0.98, 0.99),
            dark: (0.07, 0.09, 0.11)
        )
        static let cardBackground = adaptiveRGB(
            light: (1.0, 1.0, 1.0),
            dark: (0.14, 0.16, 0.19),
            lightOpacity: 0.9
        )
        static let cardBorder = adaptive(
            light: Color.black.opacity(0.08),
            dark: Color.white.opacity(0.10)
        )
        static let cardShadow = adaptive(
            light: Color.black.opacity(0.05),
            dark: Color.black.opacity(0.35)
        )
        static let primaryText = adaptiveRGB(
            light: (0.08, 0.12, 0.17),
            dark: (0.95, 0.96, 0.98)
        )
        static let secondaryText = adaptiveRGB(
            light: (0.39, 0.46, 0.53),
            dark: (0.62, 0.67, 0.73)
        )

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
