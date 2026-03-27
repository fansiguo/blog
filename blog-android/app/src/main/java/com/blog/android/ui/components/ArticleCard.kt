package com.blog.android.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.blog.android.model.Article
import com.blog.android.ui.theme.*

@Composable
fun ArticleCard(article: Article, onClick: () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .shadow(elevation = 2.dp, shape = RoundedCornerShape(12.dp))
            .background(BlogSurface)
            .border(1.dp, BlogBorder.copy(alpha = 0.5f), RoundedCornerShape(12.dp))
            .clickable(onClick = onClick)
            .padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        // Meta row
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            article.category?.let { CategoryBadge(it.name) }
            Text(
                text = article.createdAt.take(10),
                fontSize = 12.sp,
                color = BlogTextMuted
            )
        }

        // Title
        Text(
            text = article.title,
            fontSize = 20.sp,
            fontWeight = FontWeight.Bold,
            fontFamily = FontFamily.Serif,
            color = BlogText,
            maxLines = 2,
            overflow = TextOverflow.Ellipsis
        )

        // Summary
        article.summary?.takeIf { it.isNotEmpty() }?.let {
            Text(
                text = it,
                fontSize = 15.sp,
                color = BlogTextSecondary,
                lineHeight = 24.sp,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis
            )
        }

        // Tags
        if (article.tags.isNotEmpty()) {
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                article.tags.forEach { tag -> TagChip(tag.name) }
            }
        }

        // Read more
        Text(
            text = "阅读全文 \u2192",
            fontSize = 14.sp,
            fontWeight = FontWeight.Medium,
            color = BlogPrimary
        )
    }
}
