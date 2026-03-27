import SwiftUI

struct AdminCommentView: View {
    @StateObject private var viewModel = AdminCommentViewModel()
    @State private var showDeleteAlert = false
    @State private var commentToDelete: Int?

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.comments.isEmpty {
                LoadingView()
            } else if viewModel.comments.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 40))
                        .foregroundColor(.blogTextMuted)
                    Text("暂无评论")
                        .foregroundColor(.blogTextMuted)
                }
            } else {
                List {
                    ForEach(viewModel.comments) { comment in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(comment.nickname)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                                Text(comment.visible ? "展示中" : "已隐藏")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(comment.visible ? Color(hex: "#166534") : Color(hex: "#991b1b"))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(comment.visible ? Color(hex: "#dcfce7") : Color(hex: "#fee2e2"))
                                    .cornerRadius(4)
                            }

                            if let articleTitle = comment.articleTitle {
                                Text(articleTitle)
                                    .font(.system(size: 12))
                                    .foregroundColor(.blogTextSecondary)
                                    .lineLimit(1)
                            }

                            Text(comment.content)
                                .font(.system(size: 14))
                                .foregroundColor(.blogText)
                                .lineLimit(2)

                            HStack {
                                Text(String(comment.createdAt.prefix(10)))
                                    .font(.blogSmall)
                                    .foregroundColor(.blogTextMuted)
                                Spacer()
                                Button(comment.visible ? "隐藏" : "展示") {
                                    Task { await viewModel.toggleVisible(id: comment.id) }
                                }
                                .font(.system(size: 13))
                                .foregroundColor(.blogPrimary)

                                Button("删除") {
                                    commentToDelete = comment.id
                                    showDeleteAlert = true
                                }
                                .font(.system(size: 13))
                                .foregroundColor(.blogDanger)
                            }
                        }
                        .padding(.vertical, 4)
                        .opacity(comment.visible ? 1 : 0.6)
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
        .navigationTitle("评论管理")
        .alert("确认删除", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                if let id = commentToDelete {
                    Task { await viewModel.deleteComment(id: id) }
                }
            }
        } message: {
            Text("确定要删除此评论吗？")
        }
        .task {
            if viewModel.comments.isEmpty {
                await viewModel.loadComments()
            }
        }
    }
}
