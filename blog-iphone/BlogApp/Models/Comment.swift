import Foundation

struct Comment: Codable, Identifiable {
    let id: Int
    let nickname: String
    let email: String?
    let content: String
    let articleId: Int
    let articleTitle: String?
    let visible: Bool
    let createdAt: String
}
