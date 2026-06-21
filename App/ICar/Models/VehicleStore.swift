import Foundation
import Observation

@MainActor
@Observable
final class VehicleStore {
    private(set) var batteryPercent: Int
    private(set) var isCharging: Bool
    private(set) var chargeLimitPercent: Int
    private(set) var isClimateOn: Bool
    private(set) var targetTemperatureC: Int
    private(set) var isLocked: Bool

    var name: String { "My iCar" }
    var rangeKm: Int { batteryPercent * 4 }

    // Transient pending flags — not persisted
    private(set) var isChargingPending: Bool
    private(set) var isClimatePending: Bool
    private(set) var isSecurityPending: Bool

    init(userDefaults: UserDefaults) {
        let snapshot = Self.loadSnapshot(from: userDefaults)
        self.batteryPercent = snapshot?.batteryPercent ?? 78
        self.isCharging = snapshot?.isCharging ?? false
        self.chargeLimitPercent = snapshot?.chargeLimitPercent ?? 80
        self.isClimateOn = snapshot?.isClimateOn ?? false
        self.targetTemperatureC = snapshot?.targetTemperatureC ?? 24
        self.isLocked = snapshot?.isLocked ?? false
        self.isChargingPending = false
        self.isClimatePending = false
        self.isSecurityPending = false
        self.userDefaults = userDefaults
    }
    
    init(
        batteryPercent: Int = 78,
        isCharging: Bool = false,
        chargeLimitPercent: Int = 80,
        isClimateOn: Bool = false,
        targetTemperatureC: Int = 24,
        isLocked: Bool = true,
        isChargingPending: Bool = false,
        isClimatePending: Bool = false,
        isSecurityPending: Bool = false,
    ) {
        self.batteryPercent = batteryPercent
        self.isCharging = isCharging
        self.chargeLimitPercent = chargeLimitPercent
        self.isClimateOn = isClimateOn
        self.targetTemperatureC = targetTemperatureC
        self.isLocked = isLocked
        self.isChargingPending = isChargingPending
        self.isClimatePending = isClimatePending
        self.isSecurityPending = isSecurityPending
        self.userDefaults = nil
    }

    func startCharging() async {
        if isChargingPending {
            return
        }
        isChargingPending = true
        defer { isChargingPending = false }
        await simulateRemoteLatency()
        isCharging = true
        save()
    }

    func stopCharging() async {
        if isChargingPending {
            return
        }
        isChargingPending = true
        defer { isChargingPending = false }
        await simulateRemoteLatency()
        isCharging = false
        save()
    }

    func setChargeLimit(_ percent: Int) async {
        if isChargingPending {
            return
        }
        isChargingPending = true
        defer { isChargingPending = false }
        await simulateRemoteLatency()
        chargeLimitPercent = min(100, max(20, percent))
        save()
    }

    func startClimate() async {
        if isClimatePending {
            return
        }
        isClimatePending = true
        defer { isClimatePending = false }
        await simulateRemoteLatency()
        isClimateOn = true
        save()
    }

    func stopClimate() async {
        if isClimatePending {
            return
        }
        isClimatePending = true
        defer { isClimatePending = false }
        await simulateRemoteLatency()
        isClimateOn = false
        save()
    }

    func setTemperature(_ celsius: Int) async {
        if isClimatePending {
            return
        }
        isClimatePending = true
        defer { isClimatePending = false }
        await simulateRemoteLatency()
        targetTemperatureC = min(30, max(16, celsius))
        save()
    }

    func lock() async {
        if isSecurityPending {
            return
        }
        isSecurityPending = true
        defer { isSecurityPending = false }
        await simulateRemoteLatency()
        isLocked = true
        save()
    }

    func unlock() async {
        if isSecurityPending {
            return
        }
        isSecurityPending = true
        defer { isSecurityPending = false }
        await simulateRemoteLatency()
        isLocked = false
        save()
    }

    // MARK: - Persistence
    
    private let userDefaults: UserDefaults?

    private struct Snapshot: Codable {
        var batteryPercent: Int
        var isCharging: Bool
        var chargeLimitPercent: Int
        var isClimateOn: Bool
        var targetTemperatureC: Int
        var isLocked: Bool
    }

    private static let defaultsKey = "VehicleStore.snapshot"
    
    private func save() {
        if let userDefaults = self.userDefaults {
            Self.save(store: self, to: userDefaults)
        }
    }

    private static func save(store: VehicleStore, to userDefaults: UserDefaults) {
        let snapshot = Snapshot(
            batteryPercent: store.batteryPercent,
            isCharging: store.isCharging,
            chargeLimitPercent: store.chargeLimitPercent,
            isClimateOn: store.isClimateOn,
            targetTemperatureC: store.targetTemperatureC,
            isLocked: store.isLocked
        )
        if let data = try? JSONEncoder().encode(snapshot) {
            userDefaults.set(data, forKey: Self.defaultsKey)
        }
    }

    private static func loadSnapshot(from userDefaults: UserDefaults) -> Snapshot? {
        guard let data = userDefaults.data(forKey: Self.defaultsKey) else {
            return nil
        }
        return try? JSONDecoder().decode(Snapshot.self, from: data)
    }
    
    private func simulateRemoteLatency() async {
        try? await Task.sleep(for: .seconds(Double.random(in: 0.5...2.0)))
    }
    
}
