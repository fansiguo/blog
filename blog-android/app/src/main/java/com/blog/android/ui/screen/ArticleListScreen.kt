package com.blog.android.ui.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.blog.android.ui.components.*
import com.blog.android.ui.theme.*
import com.blog.android.viewmodel.ArticleListViewModel

@Composable
fun ArticleListScreen(
    viewModel: ArticleListViewModel = hiltViewModel(),
    onArticleClick: (Long) -> Unit
) {
    val articles by viewModel.articles.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val errorMessage by viewModel.errorMessage.collectAsState()
    val currentPage by viewModel.currentPage.collectAsState()
    val totalPages by viewModel.totalPages.collectAsState()

    LaunchedEffect(Unit) {
        if (articles.isEmpty()) viewModel.loadArticles()
    }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(BlogBackground),
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Header
        item {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    "最新文章",
                    fontSize = 28.sp,
                    fontWeight = FontWeight.Bold,
                    fontFamily = FontFamily.Serif,
                    color = BlogText
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    "思考、记录与分享",
                    fontSize = 15.sp,
                    color = BlogTextSecondary
                )
            }
        }

        when {
            isLoading && articles.isEmpty() -> {
                item { LoadingView(modifier = Modifier.height(300.dp)) }
            }
            errorMessage != null && articles.isEmpty() -> {
                item {
                    ErrorView(errorMessage!!) { viewModel.loadArticles() }
                }
            }
            articles.isEmpty() -> {
                item {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(200.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Text("暂无文章", color = BlogTextMuted)
                    }
                }
            }
            else -> {
                items(articles, key = { it.id }) { article ->
                    ArticleCard(article = article) {
                        onArticleClick(article.id)
                    }
                }
                item {
                    PaginationBar(currentPage, totalPages,
                        onPrevious = { viewModel.previousPage() },
                        onNext = { viewModel.nextPage() }
                    )
                }
            }
        }
    }
}
