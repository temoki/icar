import Foundation
import Observation
import AppIntents

@MainActor
@Observable
final class CarModel {
    private(set) var lockState: LockState
    private(set) var lockActionStatus: CarActionStatus<LockState>
    private(set) var unlockActionStatus: CarActionStatus<LockState>

    private let store: CarStore

    init(store: CarStore) {
        self.store = store
        self.lockState = store.load()
        self.lockActionStatus = .initial
        self.unlockActionStatus = .initial
    }

    func lock() {
        Task<Void, Never> {
            for await status in LockCarAction().execute(currentState: lockState) {
                lockActionStatus = status
                if case .completed(let newState) = status {
                    lockState = newState
                    sync()
                }
                _ = try? await IntentDonationManager.shared.donate(intent: LockCarIntent())
            }
        }
    }

    func unlock() {
        Task<Void, Never> {
            for await status in UnlockCarAction().execute(currentState: lockState) {
                unlockActionStatus = status
                if case .completed(let newState) = status {
                    lockState = newState
                    sync()
                }
                _ = try? await IntentDonationManager.shared.donate(intent: UnlockCarIntent())
            }
        }
    }
    
    private func sync() {
        store.save(lockState: lockState)
    }
}

nonisolated struct LockState: Equatable, Codable, Sendable {
    var isLocked: Bool
}
