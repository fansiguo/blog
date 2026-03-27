import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum Endpoint {
    // Public
    case articles(page: Int, size: Int = AppConfig.pageSize)
    case articleDetail(id: Int)
    case comments(articleId: Int, page: Int, size: Int = AppConfig.pageSize)
    case postComment(articleId: Int)
    case categories
    case tags

    // Auth
    case login

    // Admin
    case adminArticles(page: Int, size: Int = AppConfig.pageSize)
    case adminArticleDetail(id: Int)
    case adminCreateArticle
    case adminUpdateArticle(id: Int)
    case adminDeleteArticle(id: Int)
    case adminCategories(page: Int = 0, size: Int = AppConfig.maxPageSize)
    case adminCreateCategory
    case adminUpdateCategory(id: Int)
    case adminDeleteCategory(id: Int)
    case adminTags(page: Int = 0, size: Int = AppConfig.maxPageSize)
    case adminCreateTag
    case adminUpdateTag(id: Int)
    case adminDeleteTag(id: Int)
    case adminComments(page: Int, size: Int = AppConfig.pageSize)
    case adminToggleComment(id: Int)
    case adminDeleteComment(id: Int)
    case upload

    var path: String {
        switch self {
        case .articles: return "/articles"
        case .articleDetail(let id): return "/articles/\(id)"
        case .comments(let articleId, _, _): return "/articles/\(articleId)/comments"
        case .postComment(let articleId): return "/articles/\(articleId)/comments"
        case .categories: return "/categories"
        case .tags: return "/tags"
        case .login: return "/auth/login"
        case .adminArticles: return "/admin/articles"
        case .adminArticleDetail(let id): return "/admin/articles/\(id)"
        case .adminCreateArticle: return "/admin/articles"
        case .adminUpdateArticle(let id): return "/admin/articles/\(id)"
        case .adminDeleteArticle(let id): return "/admin/articles/\(id)"
        case .adminCategories: return "/admin/categories"
        case .adminCreateCategory: return "/admin/categories"
        case .adminUpdateCategory(let id): return "/admin/categories/\(id)"
        case .adminDeleteCategory(let id): return "/admin/categories/\(id)"
        case .adminTags: return "/admin/tags"
        case .adminCreateTag: return "/admin/tags"
        case .adminUpdateTag(let id): return "/admin/tags/\(id)"
        case .adminDeleteTag(let id): return "/admin/tags/\(id)"
        case .adminComments: return "/admin/comments"
        case .adminToggleComment(let id): return "/admin/comments/\(id)/toggle-visible"
        case .adminDeleteComment(let id): return "/admin/comments/\(id)"
        case .upload: return "/admin/upload"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .postComment, .login, .adminCreateArticle, .adminCreateCategory, .adminCreateTag, .upload:
            return .POST
        case .adminUpdateArticle, .adminUpdateCategory, .adminUpdateTag, .adminToggleComment:
            return .PUT
        case .adminDeleteArticle, .adminDeleteCategory, .adminDeleteTag, .adminDeleteComment:
            return .DELETE
        default:
            return .GET
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .articles(let page, let size):
            return [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "size", value: "\(size)")]
        case .comments(_, let page, let size):
            return [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "size", value: "\(size)")]
        case .adminArticles(let page, let size):
            return [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "size", value: "\(size)")]
        case .adminCategories(let page, let size):
            return [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "size", value: "\(size)")]
        case .adminTags(let page, let size):
            return [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "size", value: "\(size)")]
        case .adminComments(let page, let size):
            return [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "size", value: "\(size)")]
        default:
            return nil
        }
    }

    func urlRequest() -> URLRequest {
        var components = URLComponents(string: AppConfig.apiBaseURL + path)!
        components.queryItems = queryItems
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
