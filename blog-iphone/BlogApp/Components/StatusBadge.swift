import SwiftUI

struct StatusBadge: View {
    let status: ArticleStatus

    var body: some View {
        Text(status.displayName)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(status == .PUBLISHED ? Color(hex: "#059669") : Color(hex: "#d97706"))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(status == .PUBLISHED ? Color(hex: "#ecfdf5") : Color(hex: "#fffbeb"))
            .cornerRadius(4)
    }
}
