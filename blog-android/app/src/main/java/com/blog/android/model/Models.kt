package com.blog.android.model

import com.google.gson.annotations.SerializedName

data class Article(
    val id: Long,
    val title: String,
    val content: String? = null,
    val summary: String? = null,
    val coverImage: String? = null,
    val status: ArticleStatus,
    val category: Category? = null,
    val tags: List<Tag> = emptyList(),
    val createdAt: String,
    val updatedAt: String? = null
)

enum class ArticleStatus {
    DRAFT, PUBLISHED;

    val displayName: String
        get() = when (this) {
            DRAFT -> "草稿"
            PUBLISHED -> "已发布"
        }
}

data class Category(
    val id: Long,
    val name: String,
    val createdAt: String? = null
)

data class Tag(
    val id: Long,
    val name: String,
    val createdAt: String? = null
)

data class Comment(
    val id: Long,
    val nickname: String,
    val email: String? = null,
    val content: String,
    val articleId: Long,
    val articleTitle: String? = null,
    val visible: Boolean,
    val createdAt: String
)

data class PageResponse<T>(
    val content: List<T>,
    val totalElements: Int,
    val totalPages: Int,
    val number: Int,
    val size: Int,
    val first: Boolean,
    val last: Boolean
)

data class ArticleRequest(
    val title: String,
    val content: String,
    val summary: String,
    val coverImage: String? = null,
    val status: ArticleStatus,
    val categoryId: Long? = null,
    val tagIds: List<Long> = emptyList()
)

data class CommentRequest(
    val nickname: String,
    val email: String? = null,
    val content: String
)

data class LoginRequest(
    val username: String,
    val password: String
)

data class LoginResponse(
    val token: String,
    val nickname: String
)

data class UploadResponse(
    val url: String
)
