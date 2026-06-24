import Foundation

struct AnalyticsPoint: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let value: Double
    /// Stable key for chart series (e.g. category raw value). Avoids Charts crashes on locale change.
    let seriesKey: String?

    init(label: String, value: Double, seriesKey: String? = nil) {
        self.label = label
        self.value = value
        self.seriesKey = seriesKey
    }
}
