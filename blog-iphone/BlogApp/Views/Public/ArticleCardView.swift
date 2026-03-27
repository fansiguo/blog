import SwiftUI

struct ArticleCardView: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Meta row
            HStack(spacing: 8) {
                if let category = article.category {
                    CategoryBadge(name: category.name)
                }
                Text(formatDate(article.createdAt))
                    .font(.blogSmall)
                    .foregroundColor(.blogTextMuted)
                Spacer()
            }

            // Title
            Text(article.title)
                .font(.blogHeading)
                .foregroundColor(.blogText)
                .lineLimit(2)

            // Summary
            if let summary = article.summary, !summary.isEmpty {
                Text(summary)
                    .font(.system(size: 15))
                    .foregroundColor(.blogTextSecondary)
                    .lineSpacing(4)
                    .lineLimit(2)
            }

            // Tags
            if !article.tags.isEmpty {
                HStack(spacing: 8) {
                    ForEach(article.tags) { tag in
                        TagChip(name: tag.name)
                    }
                }
            }

            // Read more
            Text("阅读全文 \u{2192}")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.blogPrimary)
        }
        .padding(20)
        .background(Color.blogSurface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blogBorder.opacity(0.5), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        if let date = formatter.date(from: dateString) {
            let display = DateFormatter()
            display.dateFormat = "yyyy-MM-dd"
            return display.string(from: date)
        }
        return String(dateString.prefix(10))
    }
}
