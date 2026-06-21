import SwiftUI
import AppIntents

struct ChargingCard: View {
    @Environment(VehicleStore.self) private var store
    @State private var draftChargeLimit: Int = 80

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
                    Text(Double(draftChargeLimit) / 100.0, format: .percent)
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
                    Text("Current: \((Double(store.chargeLimitPercent) / 100.0).formatted(.percent))")
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
        }
        .padding()
        .background(.regularMaterial, in: .rect(cornerRadius: 16))
        .overlay {
            if store.isChargingPending {
                PendingOverlay()
            }
        }
        .allowsHitTesting(!store.isChargingPending)
        .onAppear {
            draftChargeLimit = store.chargeLimitPercent
        }
    }
}

#Preview {
    ChargingCard()
        .environment(VehicleStore())
        .padding()
}
