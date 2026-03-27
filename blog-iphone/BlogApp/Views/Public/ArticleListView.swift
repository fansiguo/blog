import SwiftUI

struct ArticleListView: View {
    @StateObject private var viewModel = ArticleListViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("最新文章")
                        .font(.blogHeadingLarge)
                        .foregroundColor(.blogText)
                    Text("思考、记录与分享")
                        .font(.system(size: 15))
                        .foregroundColor(.blogTextSecondary)
                }
                .padding(.vertical, 24)

                if viewModel.isLoading && viewModel.articles.isEmpty {
                    LoadingView()
                        .frame(minHeight: 300)
                } else if let error = viewModel.errorMessage, viewModel.articles.isEmpty {
                    ErrorView(message: error) {
                        Task { await viewModel.loadArticles() }
                    }
                    .frame(minHeight: 300)
                } else if viewModel.articles.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 40))
                            .foregroundColor(.blogTextMuted)
                        Text("暂无文章")
                            .font(.blogBody)
                            .foregroundColor(.blogTextMuted)
                    }
                    .frame(minHeight: 300)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.articles) { article in
                            NavigationLink(value: article.id) {
                                ArticleCardView(article: article)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)

                    // Pagination
                    if viewModel.totalPages > 1 {
                        HStack(spacing: 16) {
                            Button {
                                Task { await viewModel.previousPage() }
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.left")
                                    Text("上一页")
                                }
                            }
                            .disabled(viewModel.currentPage == 0)

                            Text("\(viewModel.currentPage + 1) / \(viewModel.totalPages)")
                                .font(.blogCaption)
                                .foregroundColor(.blogTextSecondary)

                            Button {
                                Task { await viewModel.nextPage() }
                            } label: {
                                HStack(spacing: 4) {
                                    Text("下一页")
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .disabled(viewModel.currentPage + 1 >= viewModel.totalPages)
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blogPrimary)
                        .padding(.vertical, 24)
                    }
                }
            }
        }
        .background(Color.blogBackground)
        .navigationDestination(for: Int.self) { id in
            ArticleDetailView(articleId: id)
        }
        .task {
            if viewModel.articles.isEmpty {
                await viewModel.loadArticles()
            }
        }
    }
}
