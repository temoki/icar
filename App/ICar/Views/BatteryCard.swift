import SwiftUI

struct BatteryCard: View {
    @Environment(VehicleStore.self) private var store

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Battery", systemImage: "battery.75percent")
                .font(.headline)

            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(.secondary.opacity(0.2), lineWidth: 10)
                        .frame(width: 90, height: 90)
                    Circle()
                        .trim(from: 0, to: CGFloat(store.batteryPercent) / 100)
                        .stroke(batteryColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .frame(width: 90, height: 90)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut, value: store.batteryPercent)
                    VStack(spacing: 0) {
                        Text("\(store.batteryPercent)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Text("%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(store.rangeKm) km")
                            .font(.title2.bold())
                        Text("Estimated range")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if store.isCharging {
                        Label("Charging", systemImage: "bolt.fill")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.green)
                    }
                }

                Spacer()
            }
        }
        .padding()
        .background(.regularMaterial, in: .rect(cornerRadius: 16))
    }

    private var batteryColor: Color {
        store.batteryPercent > 50 ? .green : store.batteryPercent > 20 ? .yellow : .red
    }
}

#Preview {
    BatteryCard()
        .environment(VehicleStore())
        .padding()
}
