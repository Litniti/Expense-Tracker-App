import Foundation
import SwiftData

@MainActor
enum SampleDataSeeder {
    static func seedIfNeeded(in modelContainer: ModelContainer) throws {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<Expense>()
        let count = try context.fetchCount(descriptor)
        guard count == 0 else { return }

        for expense in SampleData.mockExpenses {
            context.insert(expense)
        }
        try context.save()
    }
}
