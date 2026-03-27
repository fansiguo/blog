package com.blog.android.ui.screen.admin

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.blog.android.ui.components.LoadingView
import com.blog.android.ui.components.PaginationBar
import com.blog.android.ui.theme.*
import com.blog.android.viewmodel.AdminCommentViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AdminCommentScreen(viewModel: AdminCommentViewModel = hiltViewModel()) {
    val comments by viewModel.comments.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val currentPage by viewModel.currentPage.collectAsState()
    val totalPages by viewModel.totalPages.collectAsState()

    var deleteTarget by remember { mutableStateOf<Long?>(null) }

    LaunchedEffect(Unit) {
        if (comments.isEmpty()) viewModel.loadComments()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("评论管理") },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = BlogSurface)
            )
        }
    ) { padding ->
        if (isLoading && comments.isEmpty()) {
            LoadingView(modifier = Modifier.padding(padding))
        } else {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding)
                    .background(BlogBackground)
            ) {
                items(comments, key = { it.id }) { comment ->
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .background(BlogSurface)
                            .alpha(if (comment.visible) 1f else 0.6f)
                            .padding(16.dp),
                        verticalArrangement = Arrangement.spacedBy(6.dp)
                    ) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(comment.nickname, fontSize = 14.sp, fontWeight = FontWeight.SemiBold)
                            Text(
                                if (comment.visible) "展示中" else "已隐藏",
                                fontSize = 11.sp,
                                fontWeight = FontWeight.Medium,
                                color = if (comment.visible) VisibleText else HiddenText,
                                modifier = Modifier
                                    .background(
                                        if (comment.visible) VisibleBg else HiddenBg,
                                        shape = androidx.compose.foundation.shape.RoundedCornerShape(4.dp)
                                    )
                                    .padding(horizontal = 8.dp, vertical = 3.dp)
                            )
                        }
                        comment.articleTitle?.let {
                            Text(it, fontSize = 12.sp, color = BlogTextSecondary, maxLines = 1, overflow = TextOverflow.Ellipsis)
                        }
                        Text(comment.content, fontSize = 14.sp, maxLines = 2, overflow = TextOverflow.Ellipsis)
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(comment.createdAt.take(10), fontSize = 12.sp, color = BlogTextMuted)
                            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                TextButton(onClick = { viewModel.toggleVisible(comment.id) }) {
                                    Text(
                                        if (comment.visible) "隐藏" else "展示",
                                        fontSize = 13.sp,
                                        color = BlogPrimary
                                    )
                                }
                                IconButton(onClick = { deleteTarget = comment.id }) {
                                    Icon(Icons.Default.Delete, contentDescription = "删除", tint = BlogDanger, modifier = Modifier.size(18.dp))
                                }
                            }
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
            text = { Text("确定要删除此评论吗？") },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.deleteComment(id)
                    deleteTarget = null
                }) { Text("删除", color = BlogDanger) }
            },
            dismissButton = {
                TextButton(onClick = { deleteTarget = null }) { Text("取消") }
            }
        )
    }
}
