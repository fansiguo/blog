import Foundation
import SwiftUI

@MainActor
final class AdminArticleEditViewModel: ObservableObject {
    @Published var title = ""
    @Published var content = ""
    @Published var summary = ""
    @Published var coverImage: String?
    @Published var status: ArticleStatus = .DRAFT
    @Published var selectedCategoryId: Int?
    @Published var selectedTagIds: Set<Int> = []

    @Published var categories: [Category] = []
    @Published var tags: [Tag] = []

    @Published var isLoading = false
    @Published var isSaving = false
    @Published var errorMessage: String?
    @Published var isPreviewMode = false

    let articleId: Int?

    init(articleId: Int? = nil) {
        self.articleId = articleId
    }

    func loadData() async {
        isLoading = true
        async let categoriesTask: PageResponse<Category> = APIClient.shared.request(.adminCategories())
        async let tagsTask: PageResponse<Tag> = APIClient.shared.request(.adminTags())

        do {
            let (catResponse, tagResponse) = try await (categoriesTask, tagsTask)
            categories = catResponse.content
            tags = tagResponse.content
        } catch {
            // Non-fatal, can still edit
        }

        if let articleId {
            do {
                let article: Article = try await APIClient.shared.request(.adminArticleDetail(id: articleId))
                title = article.title
                content = article.content ?? ""
                summary = article.summary ?? ""
                coverImage = article.coverImage
                status = article.status
                selectedCategoryId = article.category?.id
                selectedTagIds = Set(article.tags.map(\.id))
            } catch let error as APIError {
                errorMessage = error.errorDescription
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        isLoading = false
    }

    func save() async -> Bool {
        isSaving = true
        errorMessage = nil

        let request = ArticleRequest(
            title: title,
            content: content,
            summary: summary,
            coverImage: coverImage,
            status: status,
            categoryId: selectedCategoryId,
            tagIds: Array(selectedTagIds)
        )

        do {
            if let articleId {
                let _: Article = try await APIClient.shared.request(
                    .adminUpdateArticle(id: articleId), body: request
                )
            } else {
                let _: Article = try await APIClient.shared.request(
                    .adminCreateArticle, body: request
                )
            }
            isSaving = false
            return true
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }

        isSaving = false
        return false
    }

    func uploadImage(_ imageData: Data, filename: String) async {
        do {
            let response = try await APIClient.shared.uploadImage(imageData, filename: filename)
            let imageUrl = AppConfig.baseURL + response.url
            content += "\n![image](\(imageUrl))\n"
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
