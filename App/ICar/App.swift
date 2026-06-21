import SwiftUI

@main struct App: SwiftUI.App {
    @State private var store = VehicleStore.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
