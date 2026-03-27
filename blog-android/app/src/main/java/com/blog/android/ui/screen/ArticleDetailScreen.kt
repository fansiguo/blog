package com.blog.android.ui.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.blog.android.ui.components.*
import com.blog.android.ui.theme.*
import com.blog.android.viewmodel.ArticleDetailViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ArticleDetailScreen(
    viewModel: ArticleDetailViewModel = hiltViewModel(),
    onBack: () -> Unit
) {
    val article by viewModel.article.collectAsState()
    val comments by viewModel.comments.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val errorMessage by viewModel.errorMessage.collectAsState()
    val isSubmittingComment by viewModel.isSubmittingComment.collectAsState()
    val commentError by viewModel.commentError.collectAsState()

    var nickname by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }
    var commentContent by remember { mutableStateOf("") }

    LaunchedEffect(Unit) {
        viewModel.loadArticle()
        viewModel.loadComments()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("文章详情", fontSize = 16.sp) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "返回")
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = BlogSurface
                )
            )
        }
    ) { padding ->
        when {
            isLoading -> LoadingView(modifier = Modifier.padding(padding))
            errorMessage != null -> ErrorView(errorMessage!!) { viewModel.loadArticle() }
            article != null -> {
                val art = article!!
                LazyColumn(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(padding)
                        .background(BlogBackground),
                    contentPadding = PaddingValues(16.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    // Header
                    item {
                        Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                art.category?.let { CategoryBadge(it.name) }
                                Text(art.createdAt.take(10), fontSize = 12.sp, color = BlogTextMuted)
                            }
                            Text(
                                art.title,
                                fontSize = 24.sp,
                                fontWeight = FontWeight.Bold,
                                fontFamily = FontFamily.Serif,
                                color = BlogText
                            )
                            if (art.tags.isNotEmpty()) {
                                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                    art.tags.forEach { TagChip(it.name) }
                                }
                            }
                            HorizontalDivider(color = BlogBorder)
                        }
                    }

                    // Content
                    item {
                        art.content?.let {
                            MarkdownText(
                                markdown = it,
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 8.dp)
                            )
                        }
                    }

                    // Comments section
                    item {
                        HorizontalDivider(color = BlogBorder)
                        Spacer(Modifier.height(16.dp))
                        Text(
                            "评论 (${comments.size})",
                            fontSize = 18.sp,
                            fontWeight = FontWeight.SemiBold,
                            fontFamily = FontFamily.Serif,
                            color = BlogText
                        )
                    }

                    // Comment form
                    item {
                        Column(
                            modifier = Modifier
                                .fillMaxWidth()
                                .background(BlogSurface, RoundedCornerShape(10.dp))
                                .padding(16.dp),
                            verticalArrangement = Arrangement.spacedBy(12.dp)
                        ) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.spacedBy(12.dp)
                            ) {
                                OutlinedTextField(
                                    value = nickname,
                                    onValueChange = { nickname = it },
                                    label = { Text("昵称 *") },
                                    singleLine = true,
                                    modifier = Modifier.weight(1f)
                                )
                                OutlinedTextField(
                                    value = email,
                                    onValueChange = { email = it },
                                    label = { Text("邮箱") },
                                    singleLine = true,
                                    modifier = Modifier.weight(1f)
                                )
                            }
                            OutlinedTextField(
                                value = commentContent,
                                onValueChange = { commentContent = it },
                                label = { Text("写下你的评论...") },
                                minLines = 3,
                                modifier = Modifier.fillMaxWidth()
                            )
                            commentError?.let {
                                Text(it, fontSize = 12.sp, color = BlogDanger)
                            }
                            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.End) {
                                Button(
                                    onClick = {
                                        viewModel.submitComment(
                                            nickname,
                                            email.ifEmpty { null },
                                            commentContent
                                        ) { commentContent = "" }
                                    },
                                    enabled = nickname.isNotEmpty() && commentContent.isNotEmpty() && !isSubmittingComment,
                                    colors = ButtonDefaults.buttonColors(containerColor = BlogPrimary)
                                ) {
                                    if (isSubmittingComment) {
                                        CircularProgressIndicator(
                                            modifier = Modifier.size(16.dp),
                                            color = BlogSurface,
                                            strokeWidth = 2.dp
                                        )
                                    } else {
                                        Text("提交评论")
                                    }
                                }
                            }
                        }
                    }

                    // Comment list
                    if (comments.isEmpty()) {
                        item {
                            Box(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 20.dp),
                                contentAlignment = Alignment.Center
                            ) {
                                Text("暂无评论", color = BlogTextMuted)
                            }
                        }
                    } else {
                        items(comments, key = { it.id }) { comment ->
                            Column(modifier = Modifier.padding(vertical = 10.dp)) {
                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween
                                ) {
                                    Text(
                                        comment.nickname,
                                        fontSize = 15.sp,
                                        fontWeight = FontWeight.SemiBold,
                                        color = BlogText
                                    )
                                    Text(
                                        comment.createdAt.take(10),
                                        fontSize = 12.sp,
                                        color = BlogTextMuted
                                    )
                                }
                                Spacer(Modifier.height(6.dp))
                                Text(comment.content, fontSize = 15.sp, color = BlogTextSecondary)
                                Spacer(Modifier.height(10.dp))
                                HorizontalDivider(color = BlogBorderLight)
                            }
                        }
                    }
                }
            }
        }
    }
}

private val RoundedCornerShape = androidx.compose.foundation.shape.RoundedCornerShape
