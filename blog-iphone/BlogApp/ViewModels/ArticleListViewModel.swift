import Foundation

@MainActor
final class ArticleListViewModel: ObservableObject {
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
                .articles(page: page)
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

    func nextPage() async {
        guard currentPage + 1 < totalPages else { return }
        await loadArticles(page: currentPage + 1)
    }

    func previousPage() async {
        guard currentPage > 0 else { return }
        await loadArticles(page: currentPage - 1)
    }
}
