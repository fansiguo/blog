import SwiftUI

struct CommentSectionView: View {
    @ObservedObject var viewModel: ArticleDetailViewModel
    @State private var nickname = ""
    @State private var email = ""
    @State private var commentContent = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("评论 (\(viewModel.comments.count))")
                .font(.blogHeadingSmall)
                .foregroundColor(.blogText)

            // Comment form
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    TextField("昵称 *", text: $nickname)
                        .textFieldStyle(.roundedBorder)
                    TextField("邮箱 (可选)", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                }

                TextEditor(text: $commentContent)
                    .frame(minHeight: 80)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.blogBorder, lineWidth: 1)
                    )
                    .overlay(
                        Group {
                            if commentContent.isEmpty {
                                Text("写下你的评论...")
                                    .foregroundColor(.blogTextMuted)
                                    .padding(8)
                                    .allowsHitTesting(false)
                            }
                        },
                        alignment: .topLeading
                    )

                if let error = viewModel.commentError {
                    Text(error)
                        .font(.blogSmall)
                        .foregroundColor(.blogDanger)
                }

                HStack {
                    Spacer()
                    Button {
                        Task {
                            let success = await viewModel.submitComment(
                                nickname: nickname,
                                email: email.isEmpty ? nil : email,
                                content: commentContent
                            )
                            if success {
                                commentContent = ""
                            }
                        }
                    } label: {
                        if viewModel.isSubmittingComment {
                            ProgressView()
                                .frame(width: 80)
                        } else {
                            Text("提交评论")
                                .font(.system(size: 14, weight: .medium))
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blogPrimary)
                    .disabled(nickname.isEmpty || commentContent.isEmpty || viewModel.isSubmittingComment)
                }
            }
            .padding(16)
            .background(Color.blogSurface)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blogBorder.opacity(0.5), lineWidth: 1)
            )

            // Comment list
            if viewModel.comments.isEmpty {
                Text("暂无评论")
                    .font(.blogBody)
                    .foregroundColor(.blogTextMuted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.comments) { comment in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(comment.nickname)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.blogText)
                                Spacer()
                                Text(String(comment.createdAt.prefix(10)))
                                    .font(.blogSmall)
                                    .foregroundColor(.blogTextMuted)
                            }
                            Text(comment.content)
                                .font(.system(size: 15))
                                .foregroundColor(.blogTextSecondary)
                        }
                        .padding(.vertical, 14)
                        if comment.id != viewModel.comments.last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
    }
}
