import SwiftUI
import Toasts

struct DashboardView: View {
    @Environment(CarModel.self) private var model
    @Environment(\.presentToast) private var presentToast
    
    @State private var confirmation: Confirmation?

    var body: some View {
        VStack(spacing: 16) {
            Image("Car")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .clipShape(.rect(cornerRadius: 16))
                .overlay {
                    if model.lockActionStatus == .requesting || model.lockActionStatus == .requesting {
                        ProgressView()
                    }
                }
            
            HStack(spacing: 8) {
                Image(
                    systemName: model.lockState.isLocked
                    ? "car.side.lock.fill"
                    : "car.side.lock.open.fill"
                )
                .foregroundStyle(
                    model.lockState.isLocked ? .green : .orange
                )
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    confirmation = .init(
                        message: "Would you like to lock your car?",
                        okAction: { model.lock() }
                    )
                }, label: {
                    Image(systemName: "lock.fill")
                        .frame(width: 44, height: 44)
                })
                
                Button(action: {
                    confirmation = .init(
                        message: "Would you like to unlock your car?",
                        okAction: { model.unlock() }
                    )
                }, label: {
                    Image(systemName: "lock.open.fill")
                        .frame(width: 44, height: 44)
                })
            }
            .font(.system(size: 20))
            .buttonStyle(.glass)
            .disabled(model.lockActionStatus.inProgress || model.unlockActionStatus.inProgress)
        }
        .padding()
        .navigationTitle("My iCar")
        .onChange(of: model.lockActionStatus) {
            switch model.lockActionStatus {
            case .requested:
                presentInfoToast("Locking...")
            case .completed:
                presentLocalNotification("Locked", icon: "✅")
            case .cancelled:
                presentLocalNotification("Already locked", icon: "⚠️")
            case .failed:
                presentLocalNotification("Locking failed", icon: "❌")
            default:
                break
            }
        }
        .onChange(of: model.unlockActionStatus) {
            switch model.unlockActionStatus {
            case .requested:
                presentInfoToast("Unlocking...")
            case .completed:
                presentLocalNotification("Unlocked", icon: "✅")
            case .cancelled:
                presentLocalNotification("Already unlocked", icon: "⚠️")
            case .failed:
                presentLocalNotification("Unlocking failed", icon: "❌")
            default:
                break
            }
        }
        .alert(item: $confirmation) { c in
            Alert(
                title: Text(c.message),
                primaryButton: .default(Text("OK"), action: c.okAction),
                secondaryButton: .cancel(),
            )
        }
    }
    
    private func presentInfoToast(_ message: LocalizedStringResource) {
        presentToast(.init(
            icon: Image(systemName: "info.circle.fill"),
            message: String(localized: message),
        ))
    }
    
    private func presentSuccessToast(_ message: LocalizedStringResource) {
        presentToast(.init(
            icon: Image(systemName: "checkmark.circle.fill").foregroundStyle(.green),
            message: String(localized: message),
        ))
    }
    
    private func presentWarningToast(_ message: LocalizedStringResource) {
        presentToast(.init(
            icon: Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.orange),
            message: String(localized: message),
        ))
    }
    
    private func presentErrorToast(_ message: LocalizedStringResource) {
        presentToast(.init(
            icon: Image(systemName: "x.circle.fill").foregroundStyle(.red),
            message: String(localized: message),
        ))
    }
    
    private func presentLocalNotification(_ message: LocalizedStringResource, icon: Character? = nil) {
        let localizedMessage = String(localized: message)
        let body: String
        if let icon {
            body = "\(icon) \(localizedMessage)"
        } else {
            body = localizedMessage
        }
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: {
                let content = UNMutableNotificationContent()
                content.body = body
                return content
            }(),
            trigger: nil,
        )
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

private struct Confirmation: Identifiable {
    var id: UUID
    var message: LocalizedStringResource
    var okAction: () -> Void
    
    init(id: UUID = .init(), message: LocalizedStringResource, okAction: @escaping () -> Void) {
        self.id = id
        self.message = message
        self.okAction = okAction
    }
}

#Preview {
    DashboardView()
        .environment(CarModel(store: CarStore()))
        .installToast(position: .top)
}
