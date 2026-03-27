import SwiftUI

struct ErrorView: View {
    let message: String
    var retryAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.blogWarning)
            Text(message)
                .font(.blogBody)
                .foregroundColor(.blogTextSecondary)
                .multilineTextAlignment(.center)
            if let retryAction {
                Button("重试") {
                    retryAction()
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.blogPrimary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
