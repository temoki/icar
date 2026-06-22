import Foundation

@MainActor
final class CarStore {
    private let userDefaults: UserDefaults
    private static let defaultsKey = "CarStore.snapshot"

    private struct Snapshot: Codable {
        var isLocked: Bool
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func load() -> LockState {
        guard let data = userDefaults.data(forKey: Self.defaultsKey),
              let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data) else {
            return LockState(isLocked: false)
        }
        return LockState(isLocked: snapshot.isLocked)
    }

    func save(lockState: LockState) {
        let snapshot = Snapshot(isLocked: lockState.isLocked)
        if let data = try? JSONEncoder().encode(snapshot) {
            userDefaults.set(data, forKey: Self.defaultsKey)
        }
    }
}
