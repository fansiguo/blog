import Foundation

@MainActor
final class AdminTagViewModel: ObservableObject {
    @Published var tags: [Tag] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPage = 0
    @Published var totalPages = 0

    func loadTags(page: Int = 0) async {
        isLoading = true
        errorMessage = nil

        do {
            let response: PageResponse<Tag> = try await APIClient.shared.request(
                .adminTags(page: page, size: AppConfig.pageSize)
            )
            tags = response.content
            currentPage = response.number
            totalPages = response.totalPages
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func createTag(name: String) async -> Bool {
        do {
            let _: Tag = try await APIClient.shared.request(
                .adminCreateTag, body: ["name": name]
            )
            await loadTags(page: currentPage)
            return true
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            return false
        }
    }

    func updateTag(id: Int, name: String) async -> Bool {
        do {
            let _: Tag = try await APIClient.shared.request(
                .adminUpdateTag(id: id), body: ["name": name]
            )
            await loadTags(page: currentPage)
            return true
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            return false
        }
    }

    func deleteTag(id: Int) async -> Bool {
        do {
            let _: EmptyResponse = try await APIClient.shared.request(.adminDeleteTag(id: id))
            tags.removeAll { $0.id == id }
            return true
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            return false
        }
    }
}
