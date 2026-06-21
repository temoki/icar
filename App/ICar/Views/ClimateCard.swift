import SwiftUI
import AppIntents

struct ClimateCard: View {
    @Environment(VehicleStore.self) private var store
    @State private var draftTemp: Int = 22

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Climate", systemImage: "thermometer.medium")
                .font(.headline)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(store.isClimateOn ? "Climate On" : "Climate Off")
                        .font(.subheadline.weight(.medium))
                    Text("\(store.targetTemperatureC)\u{00B0}C")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if store.isClimateOn {
                    Button(intent: StopClimateIntent()) {
                        Label("Stop", systemImage: "stop.fill")
                    }
                    .buttonStyle(.glass)
                } else {
                    Button(intent: StartClimateIntent()) {
                        Label("Start", systemImage: "play.fill")
                    }
                    .buttonStyle(.glass)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Target Temperature")
                    .font(.subheadline)
                HStack(spacing: 12) {
                    Stepper(value: $draftTemp, in: 16...30) {
                        Text("\(draftTemp)\u{00B0}C")
                            .font(.title3.monospacedDigit().weight(.semibold))
                            .frame(minWidth: 64, alignment: .leading)
                    }
                    Spacer()
                    Button(intent: SetCabinTemperatureIntent(temperature: draftTemp)) {
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
            if store.isClimatePending {
                PendingOverlay()
            }
        }
        .allowsHitTesting(!store.isClimatePending)
        .onAppear { draftTemp = store.targetTemperatureC }
    }
}

#Preview {
    ClimateCard()
        .environment(VehicleStore())
        .padding()
}
