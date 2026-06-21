import AppIntents

struct LockVehicleIntent: AppIntent {
    static var title: LocalizedStringResource = "Lock Vehicle"
    static var description = IntentDescription("Lock the vehicle doors.")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        VehicleStore.shared.isSecurityPending = true
        defer { VehicleStore.shared.isSecurityPending = false }
        try await VehicleStore.simulateRemoteLatency()
        VehicleStore.shared.lock()
        return .result(dialog: "Vehicle locked.")
    }
}

struct UnlockVehicleIntent: AppIntent {
    static var title: LocalizedStringResource = "Unlock Vehicle"
    static var description = IntentDescription("Unlock the vehicle doors.")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        VehicleStore.shared.isSecurityPending = true
        defer { VehicleStore.shared.isSecurityPending = false }
        try await VehicleStore.simulateRemoteLatency()
        VehicleStore.shared.unlock()
        return .result(dialog: "Vehicle unlocked.")
    }
}

struct FindVehicleIntent: AppIntent {
    static var title: LocalizedStringResource = "Find Vehicle"
    static var description = IntentDescription("Flash lights and honk to locate the vehicle.")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        VehicleStore.shared.isSecurityPending = true
        defer { VehicleStore.shared.isSecurityPending = false }
        try await VehicleStore.simulateRemoteLatency()
        VehicleStore.shared.triggerFind()
        return .result(dialog: "Honking and flashing lights to help you find the vehicle.")
    }
}
