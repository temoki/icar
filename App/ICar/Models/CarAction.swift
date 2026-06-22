nonisolated enum CarActionStatus<State: Equatable & Sendable>: Equatable, Sendable {
    case initial
    case requesting
    case requested
    case completed(State)
    case failed
    case cancelled
}

extension CarActionStatus {
    var inProgress: Bool {
        switch self {
        case .requesting, .requested: true
        default: false
        }
    }
    
    var isFinished: Bool {
        switch self {
        case .completed, .failed, .cancelled: true
        default: false
        }
    }
}

protocol CarAction {
    associatedtype State: Equatable & Sendable
    func execute(currentState: State?) -> AsyncStream<CarActionStatus<State>>
}

struct LockCarAction: CarAction {
    typealias State = LockState

    func execute(currentState: State?) -> AsyncStream<CarActionStatus<State>> {
        AsyncStream { continuation in
            Task {
                continuation.yield(.initial)
                await waitVeryShort()
                continuation.yield(.requesting)
                await waitShort()
                continuation.yield(.requested)
                await waitLong()
                if let currentState, currentState.isLocked {
                    continuation.yield(.cancelled)
                } else if Int.random(in: 1...10) == 4 {
                    continuation.yield(.failed)
                } else {
                    continuation.yield(.completed(.init(isLocked: true)))
                }
                continuation.finish()
            }
        }
    }
}


struct UnlockCarAction: CarAction {
    typealias State = LockState
    
    func execute(currentState: State?) -> AsyncStream<CarActionStatus<State>> {
        AsyncStream { continuation in
            Task {
                continuation.yield(.initial)
                await waitVeryShort()
                continuation.yield(.requesting)
                await waitShort()
                continuation.yield(.requested)
                await waitLong()
                if let currentState, !currentState.isLocked {
                    continuation.yield(.cancelled)
                } else if Int.random(in: 1...10) == 4 {
                    continuation.yield(.failed)
                } else {
                    continuation.yield(.completed(.init(isLocked: false)))
                }
                continuation.finish()
            }
        }
    }
}
