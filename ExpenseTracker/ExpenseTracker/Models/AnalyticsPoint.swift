import Foundation

struct AnalyticsPoint: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let value: Double
}
