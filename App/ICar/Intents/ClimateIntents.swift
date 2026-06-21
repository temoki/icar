import AppIntents

struct StartClimateIntent: AppIntent {
    static let title: LocalizedStringResource = "Start Climate"
    static let description = IntentDescription("Start pre-conditioning the vehicle cabin.")
    static let supportedModes: IntentModes = .background

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        VehicleStore.shared.isClimatePending = true
        defer { VehicleStore.shared.isClimatePending = false }
        try await VehicleStore.simulateRemoteLatency()
        let store = VehicleStore.shared
        store.startClimate()
        return .result(dialog: "Climate started at \(store.targetTemperatureC)\u{00B0}C.")
    }
}

struct StopClimateIntent: AppIntent {
    static let title: LocalizedStringResource = "Stop Climate"
    static let description = IntentDescription("Stop the vehicle cabin climate control.")
    static let supportedModes: IntentModes = .background

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        VehicleStore.shared.isClimatePending = true
        defer { VehicleStore.shared.isClimatePending = false }
        try await VehicleStore.simulateRemoteLatency()
        VehicleStore.shared.stopClimate()
        return .result(dialog: "Climate turned off.")
    }
}

struct SetCabinTemperatureIntent: AppIntent {
    static let title: LocalizedStringResource = "Set Cabin Temperature"
    static let description = IntentDescription("Set the target cabin temperature.")
    static let supportedModes: IntentModes = .background

    @Parameter(title: "Temperature (\u{00B0}C)", inclusiveRange: (16, 30))
    var temperature: Int

    init() { temperature = 22 }
    init(temperature: Int) { self.temperature = temperature }

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        VehicleStore.shared.isClimatePending = true
        defer { VehicleStore.shared.isClimatePending = false }
        try await VehicleStore.simulateRemoteLatency()
        VehicleStore.shared.setTemperature(temperature)
        return .result(dialog: "Cabin temperature set to \(temperature)\u{00B0}C.")
    }
}
