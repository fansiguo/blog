import Foundation

enum APIError: LocalizedError {
    case unauthorized
    case notFound
    case badRequest(String)
    case serverError(Int)
    case networkError(Error)
    case decodingError(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .unauthorized: return "登录已过期，请重新登录"
        case .notFound: return "请求的资源不存在"
        case .badRequest(let msg): return msg
        case .serverError(let code): return "服务器错误 (\(code))"
        case .networkError(let error): return "网络错误: \(error.localizedDescription)"
        case .decodingError: return "数据解析失败"
        case .unknown: return "未知错误"
        }
    }
}
