import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    private let container: AppContainer
    @StateObject private var appSession: AppSession

    init() {
        let container = AppContainer.live()
        self.container = container
        _appSession = StateObject(wrappedValue: AppSession(container: container))
    }

    var sharedModelContainer: ModelContainer {
        container.modelContainer
    }

    var body: some Scene {
        WindowGroup {
            RootTabView(container: container)
                .environmentObject(appSession)
                .preferredColorScheme(appSession.preferredColorScheme)
        }
        .modelContainer(sharedModelContainer)
    }
}

private extension AppContainer {
    static func live() -> AppContainer {
        let schema = Schema([
            Expense.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            let settingsService = UserDefaultsSettingsService()
            let expenseService = SwiftDataExpenseService(modelContainer: modelContainer)
            return AppContainer(
                modelContainer: modelContainer,
                expenseService: expenseService,
                settingsService: settingsService
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
