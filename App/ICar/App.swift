import SwiftUI
import AppIntents

@main struct App: SwiftUI.App {
    @State private var vehicleStore: VehicleStore
    
    init() {
        let vehicleStore = VehicleStore(userDefaults: .standard)
        AppDependencyManager.shared.add(dependency: vehicleStore)
        self._vehicleStore = .init(initialValue: vehicleStore)
    }

    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(vehicleStore)
        }
    }
}
