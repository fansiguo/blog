import SwiftUI
import PhotosUI

struct AdminArticleEditView: View {
    @StateObject private var viewModel: AdminArticleEditViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhoto: PhotosPickerItem?

    init(articleId: Int? = nil) {
        _viewModel = StateObject(wrappedValue: AdminArticleEditViewModel(articleId: articleId))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        // Title
                        TextField("文章标题", text: $viewModel.title)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(12)
                            .background(Color.blogSurface)
                            .cornerRadius(8)

                        // Summary
                        TextField("文章摘要", text: $viewModel.summary)
                            .font(.system(size: 15))
                            .foregroundColor(.blogTextSecondary)
                            .padding(12)
                            .background(Color.blogSurface)
                            .cornerRadius(8)

                        // Editor
                        VStack(spacing: 0) {
                            // Tabs
                            HStack(spacing: 0) {
                                Button {
                                    viewModel.isPreviewMode = false
                                } label: {
                                    Text("编写")
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .foregroundColor(viewModel.isPreviewMode ? .blogTextSecondary : .blogPrimary)
                                }

                                Button {
                                    viewModel.isPreviewMode = true
                                } label: {
                                    Text("预览")
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .foregroundColor(viewModel.isPreviewMode ? .blogPrimary : .blogTextSecondary)
                                }

                                Spacer()

                                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 14))
                                        .foregroundColor(.blogTextSecondary)
                                        .padding(10)
                                }
                            }
                            .background(Color.blogBorderLight)

                            Divider()

                            if viewModel.isPreviewMode {
                                MarkdownView(markdown: viewModel.content)
                                    .frame(minHeight: 300)
                                    .padding(8)
                            } else {
                                TextEditor(text: $viewModel.content)
                                    .font(.system(size: 15, design: .monospaced))
                                    .frame(minHeight: 300)
                                    .padding(4)
                            }
                        }
                        .background(Color.blogSurface)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blogBorder, lineWidth: 1)
                        )

                        // Settings
                        VStack(alignment: .leading, spacing: 16) {
                            Text("发布设置")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.blogText)

                            // Status
                            Picker("状态", selection: $viewModel.status) {
                                Text("草稿").tag(ArticleStatus.DRAFT)
                                Text("发布").tag(ArticleStatus.PUBLISHED)
                            }
                            .pickerStyle(.segmented)

                            // Category
                            VStack(alignment: .leading, spacing: 6) {
                                Text("分类")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blogTextSecondary)
                                Picker("选择分类", selection: $viewModel.selectedCategoryId) {
                                    Text("无分类").tag(nil as Int?)
                                    ForEach(viewModel.categories) { cat in
                                        Text(cat.name).tag(cat.id as Int?)
                                    }
                                }
                                .pickerStyle(.menu)
                            }

                            // Tags
                            VStack(alignment: .leading, spacing: 8) {
                                Text("标签")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blogTextSecondary)

                                FlowLayout(spacing: 8) {
                                    ForEach(viewModel.tags) { tag in
                                        Button {
                                            if viewModel.selectedTagIds.contains(tag.id) {
                                                viewModel.selectedTagIds.remove(tag.id)
                                            } else {
                                                viewModel.selectedTagIds.insert(tag.id)
                                            }
                                        } label: {
                                            Text(tag.name)
                                                .font(.system(size: 13))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(
                                                    viewModel.selectedTagIds.contains(tag.id)
                                                        ? Color.blogPrimary : Color.blogBorderLight
                                                )
                                                .foregroundColor(
                                                    viewModel.selectedTagIds.contains(tag.id)
                                                        ? .white : .blogTextSecondary
                                                )
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.blogSurface)
                        .cornerRadius(8)

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.blogSmall)
                                .foregroundColor(.blogDanger)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .background(Color.blogBackground)
        .navigationTitle(viewModel.articleId == nil ? "新建文章" : "编辑文章")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        if await viewModel.save() {
                            dismiss()
                        }
                    }
                } label: {
                    if viewModel.isSaving {
                        ProgressView()
                    } else {
                        Text("保存")
                            .fontWeight(.semibold)
                    }
                }
                .disabled(viewModel.title.isEmpty || viewModel.isSaving)
            }
        }
        .onChange(of: selectedPhoto) { _, newValue in
            guard let item = newValue else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    await viewModel.uploadImage(data, filename: "photo.jpg")
                }
                selectedPhoto = nil
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}

// Simple flow layout for tags
struct FlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}
