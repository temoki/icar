import AppIntents

struct StartClimateIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Climate"
    static var description = IntentDescription("Start pre-conditioning the vehicle cabin.")
    static var openAppWhenRun: Bool = false

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
    static var title: LocalizedStringResource = "Stop Climate"
    static var description = IntentDescription("Stop the vehicle cabin climate control.")
    static var openAppWhenRun: Bool = false

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
    static var title: LocalizedStringResource = "Set Cabin Temperature"
    static var description = IntentDescription("Set the target cabin temperature.")
    static var openAppWhenRun: Bool = false

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
