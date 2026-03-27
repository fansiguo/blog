import Foundation

@MainActor
final class AdminCommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPage = 0
    @Published var totalPages = 0

    func loadComments(page: Int = 0) async {
        isLoading = true
        errorMessage = nil

        do {
            let response: PageResponse<Comment> = try await APIClient.shared.request(
                .adminComments(page: page)
            )
            comments = response.content
            currentPage = response.number
            totalPages = response.totalPages
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func toggleVisible(id: Int) async {
        do {
            let updated: Comment = try await APIClient.shared.request(.adminToggleComment(id: id))
            if let idx = comments.firstIndex(where: { $0.id == id }) {
                comments[idx] = updated
            }
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
    }

    func deleteComment(id: Int) async -> Bool {
        do {
            let _: EmptyResponse = try await APIClient.shared.request(.adminDeleteComment(id: id))
            comments.removeAll { $0.id == id }
            return true
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            return false
        }
    }

    func nextPage() async {
        guard currentPage + 1 < totalPages else { return }
        await loadComments(page: currentPage + 1)
    }

    func previousPage() async {
        guard currentPage > 0 else { return }
        await loadComments(page: currentPage - 1)
    }
}
