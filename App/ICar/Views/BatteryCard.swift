import SwiftUI
import AppIntents

struct BatteryCard: View {
    @Environment(VehicleStore.self) private var store
    @State private var draftChargeLimit: Int = 80

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Battery", systemImage: batteryImage)
                .font(.headline)

            HStack(spacing: 20) {
                Gauge(
                    value: CGFloat(store.batteryPercent) / 100,
                    label: {
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            Text("\(store.batteryPercent)")
                                .font(.title2.weight(.bold))
                            Text("%")
                                .font(.caption2.weight(.medium))
                        }
                    }
                )
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(batteryColor)

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(store.rangeKm) km")
                        .font(.title2.weight(.bold))
                    Text("Estimated range")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
                
                if store.isCharging {
                    Button(intent: StopChargingIntent()) {
                        Label("Stop", systemImage: "bolt.slash.fill")
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button(intent: StartChargingIntent()) {
                        Label("Start", systemImage: "bolt.fill")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }

            Divider()

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
                    .buttonStyle(.borderedProminent)
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

    private var batteryColor: Color {
        store.batteryPercent > 50 ? .green : store.batteryPercent > 20 ? .yellow : .red
    }
    
    private var batteryImage: String {
        store.isCharging ? "battery.100percent.bolt"
        : store.batteryPercent > 95 ? "battery.100percent"
        : store.batteryPercent > 75 ? "battery.75percent"
        : store.batteryPercent > 45 ? "battery.50percent"
        : store.batteryPercent > 15 ? "battery.25percent"
        : "battery.0percent"
    }
}

#Preview {
    BatteryCard()
        .environment(VehicleStore())
        .padding()
}
