import AppIntents

struct StartChargingIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Charging"
    static var description = IntentDescription("Start charging the vehicle.")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        VehicleStore.shared.startCharging()
        return .result(dialog: "Charging started.")
    }
}

struct StopChargingIntent: AppIntent {
    static var title: LocalizedStringResource = "Stop Charging"
    static var description = IntentDescription("Stop charging the vehicle.")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        VehicleStore.shared.stopCharging()
        return .result(dialog: "Charging stopped.")
    }
}

struct SetChargeLimitIntent: AppIntent {
    static var title: LocalizedStringResource = "Set Charge Limit"
    static var description = IntentDescription("Set the maximum charge level.")
    static var openAppWhenRun: Bool = false

    @Parameter(title: "Charge Limit (%)", inclusiveRange: (20, 100))
    var limit: Int

    init() { limit = 80 }
    init(limit: Int) { self.limit = limit }

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        VehicleStore.shared.setChargeLimit(limit)
        return .result(dialog: "Charge limit set to \(limit)%.")
    }
}
