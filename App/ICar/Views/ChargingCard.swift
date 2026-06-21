import SwiftUI
import AppIntents

struct ChargingCard: View {
    @Environment(VehicleStore.self) private var store
    @State private var draftChargeLimit: Int = 80
    @State private var draftDepartureTime: Date = Calendar.current.date(byAdding: .hour, value: 8, to: .now) ?? .now

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Charging", systemImage: "bolt.car.fill")
                .font(.headline)

            // Start / Stop
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(store.isCharging ? "Charging" : "Not Charging")
                        .font(.subheadline.weight(.medium))
                    Text(store.isCharging ? "Tap to stop" : "Tap to start")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if store.isCharging {
                    Button(intent: StopChargingIntent()) {
                        Label("Stop", systemImage: "bolt.slash.fill")
                    }
                    .buttonStyle(.glass)
                } else {
                    Button(intent: StartChargingIntent()) {
                        Label("Start", systemImage: "bolt.fill")
                    }
                    .buttonStyle(.glass)
                }
            }

            Divider()

            // Charge Limit
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Charge Limit")
                        .font(.subheadline)
                    Spacer()
                    Text("\(draftChargeLimit)%")
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                Slider(
                    value: Binding(
                        get: { Double(draftChargeLimit) },
                        set: { draftChargeLimit = Int($0) }
                    ),
                    in: 20...100, step: 5
                )
                HStack {
                    Text("Current: \(store.chargeLimitPercent)%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button(intent: SetChargeLimitIntent(limit: draftChargeLimit)) {
                        Text("Set")
                            .font(.caption.weight(.semibold))
                    }
                    .buttonStyle(.glass)
                }
            }

            Divider()

            // Departure Time
            VStack(alignment: .leading, spacing: 6) {
                Text("Departure Time")
                    .font(.subheadline)
                DatePicker("", selection: $draftDepartureTime, displayedComponents: [.hourAndMinute])
                    .labelsHidden()
                HStack {
                    if let t = store.departureTime {
                        Text("Set: \(t, style: .time)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Not set")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button(intent: SetDepartureTimeIntent(time: draftDepartureTime)) {
                        Text("Set")
                            .font(.caption.weight(.semibold))
                    }
                    .buttonStyle(.glass)
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: .rect(cornerRadius: 16))
        .onAppear {
            draftChargeLimit = store.chargeLimitPercent
            if let t = store.departureTime { draftDepartureTime = t }
        }
    }
}

#Preview {
    ChargingCard()
        .environment(VehicleStore.shared)
        .padding()
}
