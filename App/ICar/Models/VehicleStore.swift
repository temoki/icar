import Foundation
import Observation

@MainActor
@Observable
final class VehicleStore {
    static let shared = VehicleStore()

    private(set) var name: String = "My iCar"
    private(set) var batteryPercent: Int = 78
    private(set) var isCharging: Bool = false
    private(set) var chargeLimitPercent: Int = 80
    private(set) var isClimateOn: Bool = false
    private(set) var targetTemperatureC: Int = 22
    private(set) var isLocked: Bool = true

    var rangeKm: Int { batteryPercent * 4 }

    // Transient pending flags — not persisted
    private(set) var isChargingPending: Bool = false
    private(set) var isClimatePending: Bool = false
    private(set) var isSecurityPending: Bool = false

    private init() { load() }

    func startCharging() async {
        if isChargingPending {
            return
        }
        isChargingPending = true
        await simulateRemoteLatency()
        isCharging = true
        save()
    }

    func stopCharging() async {
        if isChargingPending {
            return
        }
        isChargingPending = true
        await simulateRemoteLatency()
        isCharging = false
        save()
        isChargingPending = false
    }

    func setChargeLimit(_ percent: Int) async {
        if isChargingPending {
            return
        }
        isChargingPending = true
        await simulateRemoteLatency()
        chargeLimitPercent = min(100, max(20, percent))
        save()
        isChargingPending = false
    }

    func startClimate() async {
        if isClimatePending {
            return
        }
        isClimatePending = true
        await simulateRemoteLatency()
        isClimateOn = true
        save()
        isClimatePending = false
    }

    func stopClimate() async {
        if isClimatePending {
            return
        }
        isClimatePending = true
        await simulateRemoteLatency()
        isClimateOn = false
        save()
        isClimatePending = false
    }

    func setTemperature(_ celsius: Int) async {
        if isClimatePending {
            return
        }
        isClimatePending = true
        await simulateRemoteLatency()
        targetTemperatureC = min(30, max(16, celsius))
        save()
        isClimatePending = false
    }

    func lock() async {
        if isSecurityPending {
            return
        }
        isSecurityPending = true
        await simulateRemoteLatency()
        isLocked = true
        save()
        isSecurityPending = false
    }

    func unlock() async {
        if isSecurityPending {
            return
        }
        isSecurityPending = true
        await simulateRemoteLatency()
        isLocked = false
        save()
        isSecurityPending = false
    }

    // MARK: - Persistence

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
        let s = Snapshot(batteryPercent: batteryPercent, isCharging: isCharging,
                         chargeLimitPercent: chargeLimitPercent,
                         isClimateOn: isClimateOn, targetTemperatureC: targetTemperatureC,
                         isLocked: isLocked)
        if let data = try? JSONEncoder().encode(s) {
            UserDefaults.standard.set(data, forKey: Self.defaultsKey)
        }
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: Self.defaultsKey),
            let s = try? JSONDecoder().decode(Snapshot.self, from: data)
        else { return }
        batteryPercent = s.batteryPercent
        isCharging = s.isCharging
        chargeLimitPercent = s.chargeLimitPercent
        isClimateOn = s.isClimateOn
        targetTemperatureC = s.targetTemperatureC
        isLocked = s.isLocked
    }
    
    private func simulateRemoteLatency() async {
        try? await Task.sleep(for: .seconds(Double.random(in: 0.5...2.0)))
    }
    
}
