package com.blog.android.repository

import com.blog.android.model.*
import com.blog.android.network.ApiService
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody.Companion.toRequestBody
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ArticleRepository @Inject constructor(private val api: ApiService) {
    suspend fun getArticles(page: Int, size: Int = 10) = api.getArticles(page, size)
    suspend fun getArticle(id: Long) = api.getArticle(id)
    suspend fun getComments(articleId: Long, page: Int) = api.getComments(articleId, page)
    suspend fun postComment(articleId: Long, request: CommentRequest) = api.postComment(articleId, request)
    suspend fun getCategories() = api.getCategories()
    suspend fun getTags() = api.getTags()

    // Admin
    suspend fun adminGetArticles(page: Int, size: Int = 10) = api.adminGetArticles(page, size)
    suspend fun adminGetArticle(id: Long) = api.adminGetArticle(id)
    suspend fun adminCreateArticle(request: ArticleRequest) = api.adminCreateArticle(request)
    suspend fun adminUpdateArticle(id: Long, request: ArticleRequest) = api.adminUpdateArticle(id, request)
    suspend fun adminDeleteArticle(id: Long) = api.adminDeleteArticle(id)

    suspend fun adminGetCategories(page: Int = 0, size: Int = 100) = api.adminGetCategories(page, size)
    suspend fun adminCreateCategory(name: String) = api.adminCreateCategory(mapOf("name" to name))
    suspend fun adminUpdateCategory(id: Long, name: String) = api.adminUpdateCategory(id, mapOf("name" to name))
    suspend fun adminDeleteCategory(id: Long) = api.adminDeleteCategory(id)

    suspend fun adminGetTags(page: Int = 0, size: Int = 100) = api.adminGetTags(page, size)
    suspend fun adminCreateTag(name: String) = api.adminCreateTag(mapOf("name" to name))
    suspend fun adminUpdateTag(id: Long, name: String) = api.adminUpdateTag(id, mapOf("name" to name))
    suspend fun adminDeleteTag(id: Long) = api.adminDeleteTag(id)

    suspend fun adminGetComments(page: Int) = api.adminGetComments(page)
    suspend fun adminToggleComment(id: Long) = api.adminToggleComment(id)
    suspend fun adminDeleteComment(id: Long) = api.adminDeleteComment(id)

    suspend fun uploadImage(imageData: ByteArray, filename: String, mimeType: String): UploadResponse {
        val requestBody = imageData.toRequestBody(mimeType.toMediaTypeOrNull())
        val part = MultipartBody.Part.createFormData("file", filename, requestBody)
        return api.uploadImage(part)
    }

    suspend fun login(request: LoginRequest) = api.login(request)
}
