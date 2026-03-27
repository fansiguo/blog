import SwiftUI

@main
struct BlogApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isLoggedIn {
                    TabView {
                        NavigationStack {
                            ArticleListView()
                        }
                        .tabItem {
                            Image(systemName: "house")
                            Text("首页")
                        }

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
                } else {
                    TabView {
                        NavigationStack {
                            ArticleListView()
                        }
                        .tabItem {
                            Image(systemName: "house")
                            Text("首页")
                        }

                        NavigationStack {
                            LoginView()
                        }
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("登录")
                        }
                    }
                    .tint(.blogPrimary)
                }
            }
            .environmentObject(authViewModel)
        }
    }
}
