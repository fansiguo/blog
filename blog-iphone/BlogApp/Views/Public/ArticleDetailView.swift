import SwiftUI

struct ArticleDetailView: View {
    let articleId: Int
    @StateObject private var viewModel: ArticleDetailViewModel

    init(articleId: Int) {
        self.articleId = articleId
        _viewModel = StateObject(wrappedValue: ArticleDetailViewModel(articleId: articleId))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task { await viewModel.loadArticle() }
                }
            } else if let article = viewModel.article {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Article header
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                if let category = article.category {
                                    CategoryBadge(name: category.name)
                                }
                                Text(String(article.createdAt.prefix(10)))
                                    .font(.blogSmall)
                                    .foregroundColor(.blogTextMuted)
                            }

                            Text(article.title)
                                .font(.blogHeadingLarge)
                                .foregroundColor(.blogText)

                            if !article.tags.isEmpty {
                                HStack(spacing: 8) {
                                    ForEach(article.tags) { tag in
                                        TagChip(name: tag.name)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)

                        Divider()
                            .padding(.horizontal, 16)

                        // Markdown content
                        if let content = article.content {
                            MarkdownView(markdown: content)
                                .frame(minHeight: 200)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 16)
                        }

                        Divider()
                            .padding(.horizontal, 16)
                            .padding(.top, 16)

                        // Comments
                        CommentSectionView(viewModel: viewModel)
                            .padding(16)
                    }
                }
            }
        }
        .background(Color.blogBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadArticle()
            await viewModel.loadComments()
        }
    }
}
