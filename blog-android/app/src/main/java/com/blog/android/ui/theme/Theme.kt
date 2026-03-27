package com.blog.android.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable

private val LightColorScheme = lightColorScheme(
    primary = BlogPrimary,
    onPrimary = BlogSurface,
    surface = BlogSurface,
    onSurface = BlogText,
    background = BlogBackground,
    onBackground = BlogText,
    error = BlogDanger,
    outline = BlogBorder,
    surfaceVariant = BlogBorderLight,
    onSurfaceVariant = BlogTextSecondary
)

@Composable
fun BlogTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = LightColorScheme,
        content = content
    )
}
