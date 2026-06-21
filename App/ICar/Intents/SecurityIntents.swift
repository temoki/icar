import AppIntents

struct LockVehicleIntent: AppIntent {
    static let title: LocalizedStringResource = "Lock Vehicle"
    static let description = IntentDescription("Lock the vehicle doors.")
    static let supportedModes: IntentModes = .background

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
    static let title: LocalizedStringResource = "Unlock Vehicle"
    static let description = IntentDescription("Unlock the vehicle doors.")
    static let supportedModes: IntentModes = .background

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
    static let title: LocalizedStringResource = "Find Vehicle"
    static let description = IntentDescription("Flash lights and honk to locate the vehicle.")
    static let supportedModes: IntentModes = .background

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        VehicleStore.shared.isSecurityPending = true
        defer { VehicleStore.shared.isSecurityPending = false }
        try await VehicleStore.simulateRemoteLatency()
        VehicleStore.shared.triggerFind()
        return .result(dialog: "Honking and flashing lights to help you find the vehicle.")
    }
}
