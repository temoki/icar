import AppIntents

struct ICarShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CheckBatteryIntent(),
            phrases: [
                "Check \(.applicationName) battery",
                "\(.applicationName)\u{306E}\u{30D0}\u{30C3}\u{30C6}\u{30EA}\u{30FC}\u{3092}\u{78BA}\u{8A8D}"
            ],
            shortTitle: "Check Battery",
            systemImageName: "battery.75percent"
        )
        AppShortcut(
            intent: StartChargingIntent(),
            phrases: [
                "Start \(.applicationName) charging",
                "\(.applicationName)\u{3092}\u{5145}\u{96FB}\u{3057}\u{3066}"
            ],
            shortTitle: "Start Charging",
            systemImageName: "bolt.fill"
        )
        AppShortcut(
            intent: StopChargingIntent(),
            phrases: [
                "Stop \(.applicationName) charging",
                "\(.applicationName)\u{306E}\u{5145}\u{96FB}\u{3092}\u{6B62}\u{3081}\u{3066}"
            ],
            shortTitle: "Stop Charging",
            systemImageName: "bolt.slash.fill"
        )
        AppShortcut(
            intent: StartClimateIntent(),
            phrases: [
                "Pre-condition my \(.applicationName)",
                "\(.applicationName)\u{3092}\u{6691}\u{3081}\u{3066}",
                "\(.applicationName)\u{3092}\u{51B7}\u{3084}\u{3057}\u{3066}"
            ],
            shortTitle: "Start Climate",
            systemImageName: "thermometer.medium"
        )
        AppShortcut(
            intent: StopClimateIntent(),
            phrases: [
                "Stop \(.applicationName) climate",
                "\(.applicationName)\u{306E}\u{7A7A}\u{8ABF}\u{3092}\u{5207}\u{3063}\u{3066}"
            ],
            shortTitle: "Stop Climate",
            systemImageName: "thermometer.medium.slash"
        )
        AppShortcut(
            intent: LockVehicleIntent(),
            phrases: [
                "Lock my \(.applicationName)",
                "\(.applicationName)\u{3092}\u{65BD}\u{9320}\u{3057}\u{3066}"
            ],
            shortTitle: "Lock",
            systemImageName: "lock.fill"
        )
        AppShortcut(
            intent: UnlockVehicleIntent(),
            phrases: [
                "Unlock my \(.applicationName)",
                "\(.applicationName)\u{3092}\u{89E3}\u{9320}\u{3057}\u{3066}"
            ],
            shortTitle: "Unlock",
            systemImageName: "lock.open.fill"
        )
        AppShortcut(
            intent: FindVehicleIntent(),
            phrases: [
                "Find my \(.applicationName)",
                "\(.applicationName)\u{3092}\u{63A2}\u{3057}\u{3066}"
            ],
            shortTitle: "Find Vehicle",
            systemImageName: "car.top.radiowaves.rear.right"
        )
    }
}
