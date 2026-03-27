import Foundation

@MainActor
final class AdminCategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPage = 0
    @Published var totalPages = 0

    func loadCategories(page: Int = 0) async {
        isLoading = true
        errorMessage = nil

        do {
            let response: PageResponse<Category> = try await APIClient.shared.request(
                .adminCategories(page: page, size: AppConfig.pageSize)
            )
            categories = response.content
            currentPage = response.number
            totalPages = response.totalPages
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func createCategory(name: String) async -> Bool {
        do {
            let _: Category = try await APIClient.shared.request(
                .adminCreateCategory, body: ["name": name]
            )
            await loadCategories(page: currentPage)
            return true
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            return false
        }
    }

    func updateCategory(id: Int, name: String) async -> Bool {
        do {
            let _: Category = try await APIClient.shared.request(
                .adminUpdateCategory(id: id), body: ["name": name]
            )
            await loadCategories(page: currentPage)
            return true
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            return false
        }
    }

    func deleteCategory(id: Int) async -> Bool {
        do {
            let _: EmptyResponse = try await APIClient.shared.request(.adminDeleteCategory(id: id))
            categories.removeAll { $0.id == id }
            return true
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            return false
        }
    }
}
