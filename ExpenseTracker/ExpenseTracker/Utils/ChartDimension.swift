import Foundation

/// Stable, non-localized identifiers for Swift Charts axes and series.
/// Localized labels must not be used here — Charts asserts when they change during RTL/LTR transitions.
enum ChartDimension {
    static let month = "Month"
    static let amount = "Amount"
    static let category = "Category"
    static let day = "Day"
    static let spent = "Spent"
    static let remaining = "Remaining"
}
