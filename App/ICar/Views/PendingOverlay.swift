import SwiftUI

struct PendingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
            ProgressView()
                .tint(.white)
                .scaleEffect(1.2)
        }
        .clipShape(.rect(cornerRadius: 16))
    }
}
