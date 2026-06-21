import AppIntents

struct StartChargingIntent: AppIntent {
    static let title: LocalizedStringResource = "Start Charging"
    static let description = IntentDescription("Start charging the vehicle.")
    static let supportedModes: IntentModes = .background

    @Dependency
    var vehicleStore: VehicleStore
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        await vehicleStore.startCharging()
        return .result(dialog: "Charging started.")
    }
}

struct StopChargingIntent: AppIntent {
    static var title: LocalizedStringResource = "Stop Charging"
    static var description = IntentDescription("Stop charging the vehicle.")
    static var openAppWhenRun: Bool = false

    @Dependency
    var vehicleStore: VehicleStore
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        await vehicleStore.stopCharging()
        return .result(dialog: "Charging stopped.")
    }
}

struct SetChargeLimitIntent: AppIntent {
    static var title: LocalizedStringResource = "Set Charge Limit"
    static var description = IntentDescription("Set the maximum charge level.")
    static var openAppWhenRun: Bool = false

    @Parameter(title: "Charge Limit (%)", inclusiveRange: (20, 100))
    var limit: Int

    @Dependency
    var vehicleStore: VehicleStore
    

    init() {
        limit = 80
    }

    init(limit: Int) {
        self.limit = limit
    }

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        await vehicleStore.setChargeLimit(limit)
        let limitFormatted = (Double(limit) / 100.0).formatted(.percent)
        return .result(dialog: "Charge limit set to \(limitFormatted).")
    }
}
