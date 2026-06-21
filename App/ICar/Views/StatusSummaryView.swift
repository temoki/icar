import SwiftUI
import FoundationModels

struct StatusSummaryView: View {
    @Environment(VehicleStore.self) private var store
    @State private var summary: String = ""

    private let model = SystemLanguageModel.default

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .foregroundStyle(.yellow)
                .font(.subheadline)
            Group {
                switch model.availability {
                case .available:
                    Text(summary.isEmpty ? "Analyzing vehicle status..." : summary)
                        .task(id: stateKey) {
                            await generateSummary()
                        }
                default:
                    Text(staticSummary)
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }

    private var stateKey: String {
        "\(store.batteryPercent)-\(store.isCharging)-\(store.isClimateOn)-\(store.isLocked)"
    }

    private var staticSummary: String {
        "Battery \(store.batteryPercent)% \u{00B7} \(store.isCharging ? "Charging" : "Not charging") \u{00B7} Climate \(store.isClimateOn ? "on" : "off") \u{00B7} \(store.isLocked ? "Locked" : "Unlocked")"
    }

    private func generateSummary() async {
        let session = LanguageModelSession(instructions: "Summarize the vehicle status in one concise sentence. Be brief.")
        let prompt = """
            Battery: \(store.batteryPercent)%, range: \(store.rangeKm) km
            Charging: \(store.isCharging ? "yes" : "no"), limit: \(store.chargeLimitPercent)%
            Climate: \(store.isClimateOn ? "on, \(store.targetTemperatureC)\u{00B0}C" : "off")
            Locked: \(store.isLocked ? "yes" : "no")
            """
        do {
            let response = try await session.respond(to: prompt)
            summary = response.content
        } catch {
            summary = staticSummary
        }
    }
}
