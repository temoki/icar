import AppIntents
import SwiftUI

struct LockCarIntent: LongRunningIntent {
    static let title: LocalizedStringResource = "Lock my car"
    static let description = IntentDescription("Lock my car's doors")
    static let supportedModes: IntentModes = .background
    
    @Parameter(description: "Skip confirmation")
    var skipConfirmation: Bool
    
    @Dependency
    var store: CarStore

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        if !skipConfirmation {
            try await requestConfirmation(
                conditions: [],
                actionName: .do,
                dialog: "Would you like to lock your car?"
            )
        }
        let (message, imageName) = try await performBackgroundTask {
            progress.totalUnitCount = 100
            let failedMessage: LocalizedStringResource = .init("Locking failed")
            let failedImageName = "xmark.circle.fill"
            var lastImageName = failedImageName
            var lastMessage = failedMessage
            var lastStatus: CarActionStatus<LockState> = .initial
            for await status in LockCarAction().execute(currentState: store.load()) {
                lastStatus = status
                switch status {
                case .initial:
                    progress.completedUnitCount = 0

                case .requesting:
                    lastMessage = "Requsting..."
                    progress.completedUnitCount = 10
                    progress.localizedDescription = String(localized: lastMessage)

                case .requested:
                    lastMessage = "Locking..."
                    progress.completedUnitCount = 30
                    progress.localizedDescription = String(localized: lastMessage)
                    
                case .cancelled:
                    lastMessage = "Already locked"
                    lastImageName = "exclamationmark.triangle.fill"
                    progress.completedUnitCount = 100
                    progress.localizedDescription = String(localized: lastMessage)

                case .failed:
                    lastMessage = failedMessage
                    lastImageName = failedImageName
                    progress.completedUnitCount = 100
                    progress.localizedDescription = String(localized: lastMessage)

                case .completed(let newState):
                    store.save(lockState: newState)
                    lastMessage = "Locked"
                    lastImageName = "checkmark.circle.fill"
                    progress.completedUnitCount = 100
                    progress.localizedDescription = String(localized: lastMessage)
                }
                progress.localizedAdditionalDescription = ""
            }
            if !lastStatus.isFinished {
                progress.completedUnitCount = 100
                progress.localizedDescription = String(localized: failedMessage)
                return (failedMessage, failedImageName)
            }
            return (lastMessage, lastImageName)
        }
        return .result(dialog: .init(full: message, systemImageName: imageName))
    }
}

struct UnlockCarIntent: LongRunningIntent {
    static let title: LocalizedStringResource = "Unlock my car"
    static let description = IntentDescription("Unlock my car's doors")
    static let supportedModes: IntentModes = .background

    @Parameter(description: "Skip confirmation")
    var skipConfirmation: Bool

    @Dependency
    var store: CarStore

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        if !skipConfirmation {
            try await requestConfirmation(
                conditions: [],
                actionName: .do,
                dialog: "Would you like to unlock your car?"
            )
        }
        let (message, imageName) = try await performBackgroundTask {
            progress.totalUnitCount = 100
            let failedMessage: LocalizedStringResource = .init("Unlocking failed")
            let failedImageName = "xmark.circle.fill"
            var lastImageName = failedImageName
            var lastMessage = failedMessage
            var lastStatus: CarActionStatus<LockState> = .initial
            for await status in UnlockCarAction().execute(currentState: store.load()) {
                lastStatus = status
                switch status {
                case .initial:
                    progress.completedUnitCount = 0

                case .requesting:
                    lastMessage = "Requsting..."
                    progress.completedUnitCount = 10
                    progress.localizedDescription = String(localized: lastMessage)

                case .requested:
                    lastMessage = "Unlocking..."
                    progress.completedUnitCount = 30
                    progress.localizedDescription = String(localized: lastMessage)

                case .cancelled:
                    lastMessage = "Already unlocked"
                    lastImageName = "exclamationmark.triangle.fill"
                    progress.completedUnitCount = 100
                    progress.localizedDescription = String(localized: lastMessage)

                case .failed:
                    lastMessage = failedMessage
                    lastImageName = failedImageName
                    progress.completedUnitCount = 100
                    progress.localizedDescription = String(localized: lastMessage)

                case .completed(let newState):
                    store.save(lockState: newState)
                    lastMessage = "Unlocked"
                    lastImageName = "checkmark.circle.fill"
                    progress.completedUnitCount = 100
                    progress.localizedDescription = String(localized: lastMessage)
                }
                progress.localizedAdditionalDescription = ""
            }
            if !lastStatus.isFinished {
                progress.completedUnitCount = 100
                progress.localizedDescription = String(localized: failedMessage)
                return (failedMessage, failedImageName)
            }
            return (lastMessage, lastImageName)
        }
        return .result(dialog: .init(full: message, systemImageName: imageName))
    }
}

struct CheckCarIntent: AppIntent {
    static let title: LocalizedStringResource = "Check my car"
    static let description = IntentDescription("Check my car state")
    static let supportedModes: IntentModes = .background
    
    @Dependency
    var store: CarStore
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        await waitShort()
        let isLocked = store.load().isLocked
        return .result(dialog: .init(
            full: isLocked ? "Your car is locked" : "Your car is unlocked",
            systemImageName: isLocked ? "car.side.lock.fill" : "car.side.lock.open.fill",
        ))
    }
}
