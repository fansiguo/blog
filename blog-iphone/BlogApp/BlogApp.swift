import SwiftUI

@main
struct BlogApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    ArticleListView()
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("首页")
                }

                if authViewModel.isLoggedIn {
                    AdminTabView()
                        .tabItem {
                            Image(systemName: "square.grid.2x2")
                            Text("管理")
                        }
                } else {
                    NavigationStack {
                        LoginView()
                    }
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("登录")
                    }
                }
            }
            .tint(.blogPrimary)
            .environmentObject(authViewModel)
        }
    }
}
