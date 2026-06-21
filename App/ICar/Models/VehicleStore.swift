import Foundation
import Observation

@MainActor
@Observable
final class VehicleStore {
    static let shared = VehicleStore()

    var name: String = "My iCar"
    var batteryPercent: Int = 78
    var isCharging: Bool = false
    var chargeLimitPercent: Int = 80
    var isClimateOn: Bool = false
    var targetTemperatureC: Int = 22
    var isLocked: Bool = true

    var rangeKm: Int { batteryPercent * 4 }

    private init() { load() }

    func startCharging() { isCharging = true; save() }
    func stopCharging() { isCharging = false; save() }
    func setChargeLimit(_ percent: Int) { chargeLimitPercent = min(100, max(20, percent)); save() }
    func startClimate() { isClimateOn = true; save() }
    func stopClimate() { isClimateOn = false; save() }
    func setTemperature(_ celsius: Int) { targetTemperatureC = min(30, max(16, celsius)); save() }
    func lock() { isLocked = true; save() }
    func unlock() { isLocked = false; save() }
    func triggerFind() {}

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
}
