import SwiftUI

struct CategoryBadge: View {
    let name: String

    var body: some View {
        Text(name.uppercased())
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.blogPrimary)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.blogPrimaryLight)
            .cornerRadius(4)
    }
}
