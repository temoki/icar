import AppIntents

struct AppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LockCarIntent(),
            phrases: [
                "Lock my \(.applicationName)",
            ],
            shortTitle: "Lock",
            systemImageName: "lock.fill"
        )
        AppShortcut(
            intent: UnlockCarIntent(),
            phrases: [
                "Unlock my \(.applicationName)",
            ],
            shortTitle: "Unlock",
            systemImageName: "lock.open.fill"
        )
        AppShortcut(
            intent: CheckCarIntent(),
            phrases: [
                "Check my \(.applicationName)",
            ],
            shortTitle: "Check",
            systemImageName: "car.fill"
        )
    }
}
