import Foundation

@MainActor
final class AdminArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPage = 0
    @Published var totalPages = 0

    func loadArticles(page: Int = 0) async {
        isLoading = true
        errorMessage = nil

        do {
            let response: PageResponse<Article> = try await APIClient.shared.request(
                .adminArticles(page: page)
            )
            articles = response.content
            currentPage = response.number
            totalPages = response.totalPages
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func deleteArticle(id: Int) async -> Bool {
        do {
            let _: EmptyResponse = try await APIClient.shared.request(.adminDeleteArticle(id: id))
            articles.removeAll { $0.id == id }
            return true
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            return false
        }
    }

    func nextPage() async {
        guard currentPage + 1 < totalPages else { return }
        await loadArticles(page: currentPage + 1)
    }

    func previousPage() async {
        guard currentPage > 0 else { return }
        await loadArticles(page: currentPage - 1)
    }
}
