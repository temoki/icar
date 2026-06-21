import SwiftUI

struct DashboardView: View {
    @Environment(VehicleStore.self) private var store

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    StatusSummaryView()
                    BatteryCard()
                    ChargingCard()
                    ClimateCard()
                    SecurityCard()
                }
                .padding()
            }
            .navigationTitle(store.name)
        }
    }
}

#Preview {
    DashboardView()
        .environment(VehicleStore.shared)
}
