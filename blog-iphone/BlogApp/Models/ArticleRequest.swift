import Foundation

struct ArticleRequest: Encodable {
    let title: String
    let content: String
    let summary: String
    let coverImage: String?
    let status: ArticleStatus
    let categoryId: Int?
    let tagIds: [Int]
}
