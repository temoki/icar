import SwiftUI
import AppIntents

struct SecurityCard: View {
    @Environment(VehicleStore.self) private var store

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Security", systemImage: "lock.shield.fill")
                .font(.headline)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(store.isLocked ? "Locked" : "Unlocked")
                        .font(.subheadline.weight(.medium))
                    Text(store.isLocked ? "Doors are secured" : "Doors are open")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: store.isLocked ? "lock.fill" : "lock.open.fill")
                    .font(.largeTitle)
                    .foregroundStyle(store.isLocked ? .green : .orange)
                    .contentTransition(.symbolEffect(.replace))
                    .animation(.spring, value: store.isLocked)
            }

            HStack(spacing: 12) {
                Button(intent: LockVehicleIntent()) {
                    Label("Lock", systemImage: "lock.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glass)
                .disabled(store.isLocked)

                Button(intent: UnlockVehicleIntent()) {
                    Label("Unlock", systemImage: "lock.open.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glass)
                .disabled(!store.isLocked)
            }
        }
        .padding()
        .background(.regularMaterial, in: .rect(cornerRadius: 16))
        .overlay {
            if store.isSecurityPending {
                PendingOverlay()
            }
        }
        .allowsHitTesting(!store.isSecurityPending)
    }
}

#Preview {
    SecurityCard()
        .environment(VehicleStore())
        .padding()
}
