import SwiftUI

struct DashboardView: View {
    @Environment(VehicleStore.self) private var store

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    CarHeroView()
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

struct CarHeroView: View {
    var body: some View {
        Image("Car")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    DashboardView()
        .environment(VehicleStore())
}
