import Foundation

@MainActor
final class ArticleDetailViewModel: ObservableObject {
    @Published var article: Article?
    @Published var comments: [Comment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var commentPage = 0
    @Published var commentTotalPages = 0
    @Published var isSubmittingComment = false
    @Published var commentError: String?

    let articleId: Int

    init(articleId: Int) {
        self.articleId = articleId
    }

    func loadArticle() async {
        isLoading = true
        errorMessage = nil

        do {
            article = try await APIClient.shared.request(.articleDetail(id: articleId))
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadComments(page: Int = 0) async {
        do {
            let response: PageResponse<Comment> = try await APIClient.shared.request(
                .comments(articleId: articleId, page: page)
            )
            comments = response.content
            commentPage = response.number
            commentTotalPages = response.totalPages
        } catch {
            // Silently fail for comments, same as web frontend
        }
    }

    func submitComment(nickname: String, email: String?, content: String) async -> Bool {
        isSubmittingComment = true
        commentError = nil

        do {
            let _: Comment = try await APIClient.shared.request(
                .postComment(articleId: articleId),
                body: CommentRequest(nickname: nickname, email: email, content: content)
            )
            await loadComments()
            isSubmittingComment = false
            return true
        } catch let error as APIError {
            commentError = error.errorDescription
        } catch {
            commentError = error.localizedDescription
        }

        isSubmittingComment = false
        return false
    }
}
