import Foundation

struct CommentRequest: Encodable {
    let nickname: String
    let email: String?
    let content: String
}
