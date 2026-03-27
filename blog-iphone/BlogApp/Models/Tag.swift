import Foundation

struct Tag: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let createdAt: String?
}
