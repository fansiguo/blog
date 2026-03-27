package com.blog.android.ui.screen.admin

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.blog.android.ui.components.*
import com.blog.android.ui.theme.*
import com.blog.android.viewmodel.AdminArticleListViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AdminArticleListScreen(
    viewModel: AdminArticleListViewModel = hiltViewModel(),
    onNewArticle: () -> Unit,
    onEditArticle: (Long) -> Unit
) {
    val articles by viewModel.articles.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val currentPage by viewModel.currentPage.collectAsState()
    val totalPages by viewModel.totalPages.collectAsState()

    var deleteTarget by remember { mutableStateOf<Long?>(null) }

    LaunchedEffect(Unit) {
        if (articles.isEmpty()) viewModel.loadArticles()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("文章管理") },
                actions = {
                    IconButton(onClick = onNewArticle) {
                        Icon(Icons.Default.Add, contentDescription = "新建文章")
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = BlogSurface)
            )
        }
    ) { padding ->
        if (isLoading && articles.isEmpty()) {
            LoadingView(modifier = Modifier.padding(padding))
        } else {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding)
                    .background(BlogBackground)
            ) {
                items(articles, key = { it.id }) { article ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .background(BlogSurface)
                            .clickable { onEditArticle(article.id) }
                            .padding(16.dp),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                article.title,
                                fontSize = 16.sp,
                                fontWeight = FontWeight.Medium,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis
                            )
                            Spacer(Modifier.height(6.dp))
                            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                StatusBadge(article.status)
                                article.category?.let {
                                    Text(it.name, fontSize = 12.sp, color = BlogTextSecondary)
                                }
                                Text(article.createdAt.take(10), fontSize = 12.sp, color = BlogTextMuted)
                            }
                        }
                        IconButton(onClick = { deleteTarget = article.id }) {
                            Icon(Icons.Default.Delete, contentDescription = "删除", tint = BlogDanger)
                        }
                    }
                    HorizontalDivider(color = BlogBorderLight)
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

    deleteTarget?.let { id ->
        AlertDialog(
            onDismissRequest = { deleteTarget = null },
            title = { Text("确认删除") },
            text = { Text("删除后无法恢复，确定要删除这篇文章吗？") },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.deleteArticle(id)
                    deleteTarget = null
                }) { Text("删除", color = BlogDanger) }
            },
            dismissButton = {
                TextButton(onClick = { deleteTarget = null }) { Text("取消") }
            }
        )
    }
}
