package com.blog.android.ui

import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.blog.android.ui.screen.*
import com.blog.android.ui.screen.admin.*
import com.blog.android.ui.theme.BlogPrimary
import com.blog.android.ui.theme.BlogSurface
import com.blog.android.viewmodel.AuthViewModel

sealed class Screen(val route: String) {
    data object Articles : Screen("articles")
    data object ArticleDetail : Screen("articles/{id}") {
        fun createRoute(id: Long) = "articles/$id"
    }
    data object Login : Screen("login")
    data object AdminArticles : Screen("admin/articles")
    data object AdminArticleNew : Screen("admin/articles/new")
    data object AdminArticleEdit : Screen("admin/articles/{id}/edit") {
        fun createRoute(id: Long) = "admin/articles/$id/edit"
    }
    data object AdminCategories : Screen("admin/categories")
    data object AdminTags : Screen("admin/tags")
    data object AdminComments : Screen("admin/comments")
}

@Composable
fun BlogApp() {
    val navController = rememberNavController()
    val authViewModel: AuthViewModel = hiltViewModel()
    val isLoggedIn by authViewModel.isLoggedIn.collectAsState()
    val currentBackStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = currentBackStackEntry?.destination?.route

    val isAdminRoute = currentRoute?.startsWith("admin") == true

    data class BottomNavItem(val route: String, val icon: @Composable () -> Unit, val label: String)

    val publicItems = listOf(
        BottomNavItem("articles", { Icon(Icons.Default.Home, contentDescription = null) }, "首页")
    )
    val authItem = if (isLoggedIn) {
        BottomNavItem("admin/articles", { Icon(Icons.Default.Dashboard, contentDescription = null) }, "管理")
    } else {
        BottomNavItem("login", { Icon(Icons.Default.Person, contentDescription = null) }, "登录")
    }
    val adminItems = listOf(
        BottomNavItem("admin/articles", { Icon(Icons.Default.Article, contentDescription = null) }, "文章"),
        BottomNavItem("admin/categories", { Icon(Icons.Default.Folder, contentDescription = null) }, "分类"),
        BottomNavItem("admin/tags", { Icon(Icons.Default.Tag, contentDescription = null) }, "标签"),
        BottomNavItem("admin/comments", { Icon(Icons.Default.Chat, contentDescription = null) }, "评论")
    )

    val bottomNavItems = if (isAdminRoute && isLoggedIn) {
        adminItems + BottomNavItem("articles", { Icon(Icons.Default.Home, contentDescription = null) }, "首页")
    } else {
        publicItems + authItem
    }

    Scaffold(
        bottomBar = {
            NavigationBar(containerColor = BlogSurface) {
                bottomNavItems.forEach { item ->
                    NavigationBarItem(
                        icon = item.icon,
                        label = { Text(item.label, fontSize = 11.sp) },
                        selected = currentRoute == item.route,
                        onClick = {
                            if (currentRoute != item.route) {
                                navController.navigate(item.route) {
                                    popUpTo(navController.graph.startDestinationId) { saveState = true }
                                    launchSingleTop = true
                                    restoreState = true
                                }
                            }
                        },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = BlogPrimary,
                            selectedTextColor = BlogPrimary
                        )
                    )
                }
            }
        }
    ) { padding ->
        NavHost(
            navController = navController,
            startDestination = Screen.Articles.route,
            modifier = Modifier.padding(padding)
        ) {
            composable(Screen.Articles.route) {
                ArticleListScreen(
                    onArticleClick = { id -> navController.navigate(Screen.ArticleDetail.createRoute(id)) }
                )
            }
            composable(
                Screen.ArticleDetail.route,
                arguments = listOf(navArgument("id") { type = NavType.LongType })
            ) {
                ArticleDetailScreen(onBack = { navController.popBackStack() })
            }
            composable(Screen.Login.route) {
                LoginScreen(viewModel = authViewModel)
            }
            composable(Screen.AdminArticles.route) {
                AdminArticleListScreen(
                    onNewArticle = { navController.navigate(Screen.AdminArticleNew.route) },
                    onEditArticle = { id -> navController.navigate(Screen.AdminArticleEdit.createRoute(id)) }
                )
            }
            composable(Screen.AdminArticleNew.route) {
                AdminArticleEditScreen(onBack = { navController.popBackStack() })
            }
            composable(
                Screen.AdminArticleEdit.route,
                arguments = listOf(navArgument("id") { type = NavType.LongType })
            ) {
                AdminArticleEditScreen(onBack = { navController.popBackStack() })
            }
            composable(Screen.AdminCategories.route) {
                AdminCategoryScreen()
            }
            composable(Screen.AdminTags.route) {
                AdminTagScreen()
            }
            composable(Screen.AdminComments.route) {
                AdminCommentScreen()
            }
        }
    }
}
