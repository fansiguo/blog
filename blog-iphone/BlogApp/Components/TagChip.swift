import SwiftUI

struct TagChip: View {
    let name: String

    var body: some View {
        Text("# \(name)")
            .font(.blogSmall)
            .foregroundColor(.blogTextMuted)
    }
}
