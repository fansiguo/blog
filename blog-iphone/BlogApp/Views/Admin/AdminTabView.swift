import SwiftUI

struct AdminTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                AdminArticleListView()
            }
            .tabItem {
                Image(systemName: "doc.text")
                Text("文章")
            }

            NavigationStack {
                AdminCategoryView()
            }
            .tabItem {
                Image(systemName: "folder")
                Text("分类")
            }

            NavigationStack {
                AdminTagView()
            }
            .tabItem {
                Image(systemName: "tag")
                Text("标签")
            }

            NavigationStack {
                AdminCommentView()
            }
            .tabItem {
                Image(systemName: "bubble.left.and.bubble.right")
                Text("评论")
            }
        }
        .tint(.blogPrimary)
    }
}
