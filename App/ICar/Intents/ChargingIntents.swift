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

struct SetDepartureTimeIntent: AppIntent {
    static var title: LocalizedStringResource = "Set Departure Time"
    static var description = IntentDescription("Set the departure time for smart charging.")
    static var openAppWhenRun: Bool = false

    @Parameter(title: "Departure Time")
    var departureTime: Date

    init() { departureTime = Calendar.current.date(byAdding: .hour, value: 8, to: .now) ?? .now }
    init(time: Date) { departureTime = time }

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        VehicleStore.shared.setDeparture(departureTime)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return .result(dialog: "Departure time set to \(formatter.string(from: departureTime)).")
    }
}
