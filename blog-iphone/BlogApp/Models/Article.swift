import Foundation

struct Article: Codable, Identifiable {
    let id: Int
    let title: String
    let content: String?
    let summary: String?
    let coverImage: String?
    let status: ArticleStatus
    let category: Category?
    let tags: [Tag]
    let createdAt: String
    let updatedAt: String?
}

enum ArticleStatus: String, Codable, CaseIterable {
    case DRAFT
    case PUBLISHED

    var displayName: String {
        switch self {
        case .DRAFT: return "草稿"
        case .PUBLISHED: return "已发布"
        }
    }
}
