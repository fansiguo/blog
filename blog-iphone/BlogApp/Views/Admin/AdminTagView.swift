import SwiftUI

struct AdminTagView: View {
    @StateObject private var viewModel = AdminTagViewModel()
    @State private var newTagName = ""
    @State private var editingId: Int?
    @State private var editingName = ""
    @State private var showDeleteAlert = false
    @State private var tagToDelete: Int?

    var body: some View {
        VStack(spacing: 0) {
            // Add bar
            HStack(spacing: 12) {
                TextField("新建标签名称", text: $newTagName)
                    .textFieldStyle(.roundedBorder)
                Button("添加") {
                    Task {
                        if await viewModel.createTag(name: newTagName) {
                            newTagName = ""
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blogPrimary)
                .disabled(newTagName.isEmpty)
            }
            .padding(16)
            .background(Color.blogSurface)

            Divider()

            if viewModel.isLoading && viewModel.tags.isEmpty {
                LoadingView()
            } else if viewModel.tags.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tag")
                        .font(.system(size: 40))
                        .foregroundColor(.blogTextMuted)
                    Text("暂无标签")
                        .foregroundColor(.blogTextMuted)
                }
                .frame(maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.tags) { tag in
                        HStack {
                            if editingId == tag.id {
                                TextField("标签名称", text: $editingName)
                                    .textFieldStyle(.roundedBorder)
                                Button("保存") {
                                    Task {
                                        if await viewModel.updateTag(id: tag.id, name: editingName) {
                                            editingId = nil
                                        }
                                    }
                                }
                                .foregroundColor(.blogPrimary)
                                Button("取消") {
                                    editingId = nil
                                }
                                .foregroundColor(.blogTextSecondary)
                            } else {
                                Text(tag.name)
                                    .font(.system(size: 15))
                                Spacer()
                                if let date = tag.createdAt {
                                    Text(String(date.prefix(10)))
                                        .font(.blogSmall)
                                        .foregroundColor(.blogTextMuted)
                                }
                                Button {
                                    editingId = tag.id
                                    editingName = tag.name
                                } label: {
                                    Text("编辑")
                                        .font(.system(size: 13))
                                        .foregroundColor(.blogPrimary)
                                }
                                Button {
                                    tagToDelete = tag.id
                                    showDeleteAlert = true
                                } label: {
                                    Text("删除")
                                        .font(.system(size: 13))
                                        .foregroundColor(.blogDanger)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blogBackground)
        .navigationTitle("标签管理")
        .toolbarBackground(Color.blogBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .alert("确认删除", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                if let id = tagToDelete {
                    Task { await viewModel.deleteTag(id: id) }
                }
            }
        } message: {
            Text("确定要删除此标签吗？")
        }
        .task {
            if viewModel.tags.isEmpty {
                await viewModel.loadTags()
            }
        }
    }
}
