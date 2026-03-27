import SwiftUI

struct AdminCategoryView: View {
    @StateObject private var viewModel = AdminCategoryViewModel()
    @State private var newCategoryName = ""
    @State private var editingId: Int?
    @State private var editingName = ""
    @State private var showDeleteAlert = false
    @State private var categoryToDelete: Int?

    var body: some View {
        VStack(spacing: 0) {
            // Add bar
            HStack(spacing: 12) {
                TextField("新建分类名称", text: $newCategoryName)
                    .textFieldStyle(.roundedBorder)
                Button("添加") {
                    Task {
                        if await viewModel.createCategory(name: newCategoryName) {
                            newCategoryName = ""
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blogPrimary)
                .disabled(newCategoryName.isEmpty)
            }
            .padding(16)
            .background(Color.blogSurface)

            Divider()

            if viewModel.isLoading && viewModel.categories.isEmpty {
                LoadingView()
            } else if viewModel.categories.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "folder")
                        .font(.system(size: 40))
                        .foregroundColor(.blogTextMuted)
                    Text("暂无分类")
                        .foregroundColor(.blogTextMuted)
                }
                .frame(maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.categories) { category in
                        HStack {
                            if editingId == category.id {
                                TextField("分类名称", text: $editingName)
                                    .textFieldStyle(.roundedBorder)
                                Button("保存") {
                                    Task {
                                        if await viewModel.updateCategory(id: category.id, name: editingName) {
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
                                Text(category.name)
                                    .font(.system(size: 15))
                                Spacer()
                                if let date = category.createdAt {
                                    Text(String(date.prefix(10)))
                                        .font(.blogSmall)
                                        .foregroundColor(.blogTextMuted)
                                }
                                Button {
                                    editingId = category.id
                                    editingName = category.name
                                } label: {
                                    Text("编辑")
                                        .font(.system(size: 13))
                                        .foregroundColor(.blogPrimary)
                                }
                                Button {
                                    categoryToDelete = category.id
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
        .background(Color.blogBackground)
        .navigationTitle("分类管理")
        .alert("确认删除", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                if let id = categoryToDelete {
                    Task { await viewModel.deleteCategory(id: id) }
                }
            }
        } message: {
            Text("确定要删除此分类吗？")
        }
        .task {
            if viewModel.categories.isEmpty {
                await viewModel.loadCategories()
            }
        }
    }
}
