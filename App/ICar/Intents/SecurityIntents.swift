import AppIntents

struct LockVehicleIntent: AppIntent {
    static let title: LocalizedStringResource = "Lock Vehicle"
    static let description = IntentDescription("Lock the vehicle doors.")
    static let supportedModes: IntentModes = .background
    
    @Dependency
    var vehicleStore: VehicleStore

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        await vehicleStore.lock()
        return .result(dialog: "Vehicle locked.")
    }
}

struct UnlockVehicleIntent: AppIntent {
    static let title: LocalizedStringResource = "Unlock Vehicle"
    static let description = IntentDescription("Unlock the vehicle doors.")
    static let supportedModes: IntentModes = .background

    @Dependency
    var vehicleStore: VehicleStore

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        await vehicleStore.unlock()
        return .result(dialog: "Vehicle unlocked.")
    }
}
