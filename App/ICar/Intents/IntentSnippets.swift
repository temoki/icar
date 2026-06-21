import SwiftUI

struct BatterySnippetView: View {
    let percent: Int
    let rangeKm: Int
    let isCharging: Bool

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(.secondary.opacity(0.2), lineWidth: 8)
                    .frame(width: 64, height: 64)
                Circle()
                    .trim(from: 0, to: CGFloat(percent) / 100)
                    .stroke(batteryColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 64, height: 64)
                    .rotationEffect(.degrees(-90))
                Text("\(percent)%")
                    .font(.system(size: 13, weight: .semibold))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("\(rangeKm) km")
                    .font(.headline)
                Text(isCharging ? "Charging" : "Not charging")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
    }

    private var batteryColor: Color {
        percent > 50 ? .green : percent > 20 ? .yellow : .red
    }
}
