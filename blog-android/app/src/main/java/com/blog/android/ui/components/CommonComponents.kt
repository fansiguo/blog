package com.blog.android.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.blog.android.model.ArticleStatus
import com.blog.android.ui.theme.*

@Composable
fun CategoryBadge(name: String) {
    Text(
        text = name.uppercase(),
        fontSize = 11.sp,
        fontWeight = FontWeight.SemiBold,
        color = BlogPrimary,
        modifier = Modifier
            .clip(RoundedCornerShape(4.dp))
            .background(BlogPrimaryLight)
            .padding(horizontal = 8.dp, vertical = 3.dp)
    )
}

@Composable
fun TagChip(name: String) {
    Text(
        text = "# $name",
        fontSize = 12.sp,
        color = BlogTextMuted
    )
}

@Composable
fun StatusBadge(status: ArticleStatus) {
    val bgColor = if (status == ArticleStatus.PUBLISHED) PublishedBg else DraftBg
    val textColor = if (status == ArticleStatus.PUBLISHED) PublishedText else DraftText
    Text(
        text = status.displayName,
        fontSize = 11.sp,
        fontWeight = FontWeight.SemiBold,
        color = textColor,
        modifier = Modifier
            .clip(RoundedCornerShape(4.dp))
            .background(bgColor)
            .padding(horizontal = 8.dp, vertical = 3.dp)
    )
}

@Composable
fun LoadingView(modifier: Modifier = Modifier) {
    Box(modifier = modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            CircularProgressIndicator(color = BlogPrimary)
            Spacer(modifier = Modifier.height(12.dp))
            Text("加载中...", fontSize = 13.sp, color = BlogTextMuted)
        }
    }
}

@Composable
fun ErrorView(message: String, onRetry: (() -> Unit)? = null) {
    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text(message, color = BlogTextSecondary)
            onRetry?.let {
                Spacer(modifier = Modifier.height(12.dp))
                TextButton(onClick = it) {
                    Text("重试", color = BlogPrimary)
                }
            }
        }
    }
}

@Composable
fun PaginationBar(
    currentPage: Int,
    totalPages: Int,
    onPrevious: () -> Unit,
    onNext: () -> Unit
) {
    if (totalPages <= 1) return
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        horizontalArrangement = Arrangement.Center,
        verticalAlignment = Alignment.CenterVertically
    ) {
        TextButton(onClick = onPrevious, enabled = currentPage > 0) {
            Text("上一页")
        }
        Text(
            "${currentPage + 1} / $totalPages",
            fontSize = 13.sp,
            color = BlogTextSecondary,
            modifier = Modifier.padding(horizontal = 16.dp)
        )
        TextButton(onClick = onNext, enabled = currentPage + 1 < totalPages) {
            Text("下一页")
        }
    }
}
