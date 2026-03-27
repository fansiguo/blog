import SwiftUI
import UIKit

@main
struct BlogApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        configureAppearance()
    }

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
            .background(Color.blogBackground)
            .environmentObject(authViewModel)
        }
    }

    private func configureAppearance() {
        let bgColor = UIColor(red: 238/255, green: 236/255, blue: 226/255, alpha: 1) // #eeece2

        // Tab bar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = bgColor
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        // Navigation bar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = bgColor
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(red: 26/255, green: 26/255, blue: 46/255, alpha: 1)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 26/255, green: 26/255, blue: 46/255, alpha: 1)]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
}
