import AppIntents
import SwiftUI

struct CheckBatteryIntent: AppIntent {
    static let title: LocalizedStringResource = "Check Battery"
    static let description = IntentDescription("Check the vehicle's battery level and range.")
    static let supportedModes: IntentModes = .background

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        let store = VehicleStore.shared
        let percent = store.batteryPercent
        let range = store.rangeKm
        let charging = store.isCharging
        let percentFormatted = (Double(percent) / 100.0).formatted(.percent)
        return .result(
            dialog: "Battery is \(percentFormatted), range approximately \(range) km.",
            view: BatterySnippetView(percent: percent, rangeKm: range, isCharging: charging)
        )
    }
}
