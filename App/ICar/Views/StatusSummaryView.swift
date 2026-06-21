import SwiftUI
import FoundationModels

struct StatusSummaryView: View {
    @Environment(VehicleStore.self) private var store
    @State private var summary: String? = nil

    private let model = SystemLanguageModel.default

    var body: some View {
        HStack(spacing: 8) {
            if let summary {
                Image(systemName: "sparkles")
                    .foregroundStyle(.yellow)
                    .font(.subheadline)
                Text(summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .task(id: stateKey) {
            await generateSummary()
        }

    }

    private var stateKey: String {
        "\(store.batteryPercent)-\(store.isCharging)-\(store.isClimateOn)-\(store.isLocked)"
    }

    private var staticSummary: String {
        "Battery \(store.batteryPercent)% \u{00B7} \(store.isCharging ? "Charging" : "Not charging") \u{00B7} Climate \(store.isClimateOn ? "on" : "off") \u{00B7} \(store.isLocked ? "Locked" : "Unlocked")"
    }

    private func generateSummary() async {
        switch model.availability {
        case .available:
            break
        case .unavailable(let reason):
            // TODO: Logging
            return
        }
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        let session = LanguageModelSession(instructions: "Summarize the vehicle status in one concise sentence. Be brief. Response in the language specified by the language code \"\(languageCode)\".")
        let prompt = """
            Battery: \(store.batteryPercent)%, range: \(store.rangeKm) km
            Charging: \(store.isCharging ? "yes" : "no"), limit: \(store.chargeLimitPercent)%
            Climate: \(store.isClimateOn ? "on, \(store.targetTemperatureC)\u{00B0}C" : "off")
            Locked: \(store.isLocked ? "yes" : "no")
            """
        do {
            let response = try await session.respond(to: prompt)
            summary = response.content
        } catch let e {
            // TODO: Logging
            summary = nil
        }
    }
}
