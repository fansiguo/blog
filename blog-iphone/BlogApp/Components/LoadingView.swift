import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)
            Text("加载中...")
                .font(.blogCaption)
                .foregroundColor(.blogTextMuted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
