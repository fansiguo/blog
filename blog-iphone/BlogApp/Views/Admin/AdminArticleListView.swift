import SwiftUI

struct AdminArticleListView: View {
    @StateObject private var viewModel = AdminArticleListViewModel()
    @State private var showDeleteAlert = false
    @State private var articleToDelete: Int?

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.articles.isEmpty {
                LoadingView()
            } else if viewModel.articles.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 40))
                        .foregroundColor(.blogTextMuted)
                    Text("暂无文章")
                        .foregroundColor(.blogTextMuted)
                }
            } else {
                List {
                    ForEach(viewModel.articles) { article in
                        NavigationLink {
                            AdminArticleEditView(articleId: article.id)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(article.title)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.blogText)
                                        .lineLimit(1)

                                    HStack(spacing: 8) {
                                        StatusBadge(status: article.status)
                                        if let category = article.category {
                                            Text(category.name)
                                                .font(.blogSmall)
                                                .foregroundColor(.blogTextSecondary)
                                        }
                                        Text(String(article.createdAt.prefix(10)))
                                            .font(.blogSmall)
                                            .foregroundColor(.blogTextMuted)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                articleToDelete = article.id
                                showDeleteAlert = true
                            } label: {
                                Label("删除", systemImage: "trash")
                            }
                        }
                    }

                    if viewModel.totalPages > 1 {
                        HStack {
                            if viewModel.currentPage > 0 {
                                Button("上一页") {
                                    Task { await viewModel.previousPage() }
                                }
                            }
                            Spacer()
                            Text("\(viewModel.currentPage + 1) / \(viewModel.totalPages)")
                                .font(.blogSmall)
                                .foregroundColor(.blogTextMuted)
                            Spacer()
                            if viewModel.currentPage + 1 < viewModel.totalPages {
                                Button("下一页") {
                                    Task { await viewModel.nextPage() }
                                }
                            }
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.blogPrimary)
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(Color.blogBackground.ignoresSafeArea())
        .navigationTitle("文章管理")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AdminArticleEditView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("确认删除", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                if let id = articleToDelete {
                    Task { await viewModel.deleteArticle(id: id) }
                }
            }
        } message: {
            Text("删除后无法恢复，确定要删除这篇文章吗？")
        }
        .task {
            if viewModel.articles.isEmpty {
                await viewModel.loadArticles()
            }
        }
    }
}
