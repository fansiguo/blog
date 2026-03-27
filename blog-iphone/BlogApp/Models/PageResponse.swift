import Foundation

struct PageResponse<T: Codable>: Codable {
    let content: [T]
    let totalElements: Int
    let totalPages: Int
    let number: Int
    let size: Int
    let first: Bool
    let last: Bool
}
