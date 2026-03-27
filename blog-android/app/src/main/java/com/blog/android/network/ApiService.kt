package com.blog.android.network

import com.blog.android.model.*
import okhttp3.MultipartBody
import retrofit2.http.*

interface ApiService {
    // Public
    @GET("articles")
    suspend fun getArticles(
        @Query("page") page: Int = 0,
        @Query("size") size: Int = 10
    ): PageResponse<Article>

    @GET("articles/{id}")
    suspend fun getArticle(@Path("id") id: Long): Article

    @GET("articles/{articleId}/comments")
    suspend fun getComments(
        @Path("articleId") articleId: Long,
        @Query("page") page: Int = 0,
        @Query("size") size: Int = 10
    ): PageResponse<Comment>

    @POST("articles/{articleId}/comments")
    suspend fun postComment(
        @Path("articleId") articleId: Long,
        @Body body: CommentRequest
    ): Comment

    @GET("categories")
    suspend fun getCategories(): List<Category>

    @GET("tags")
    suspend fun getTags(): List<Tag>

    // Auth
    @POST("auth/login")
    suspend fun login(@Body body: LoginRequest): LoginResponse

    // Admin Articles
    @GET("admin/articles")
    suspend fun adminGetArticles(
        @Query("page") page: Int = 0,
        @Query("size") size: Int = 10
    ): PageResponse<Article>

    @GET("admin/articles/{id}")
    suspend fun adminGetArticle(@Path("id") id: Long): Article

    @POST("admin/articles")
    suspend fun adminCreateArticle(@Body body: ArticleRequest): Article

    @PUT("admin/articles/{id}")
    suspend fun adminUpdateArticle(@Path("id") id: Long, @Body body: ArticleRequest): Article

    @DELETE("admin/articles/{id}")
    suspend fun adminDeleteArticle(@Path("id") id: Long)

    // Admin Categories
    @GET("admin/categories")
    suspend fun adminGetCategories(
        @Query("page") page: Int = 0,
        @Query("size") size: Int = 100
    ): PageResponse<Category>

    @POST("admin/categories")
    suspend fun adminCreateCategory(@Body body: Map<String, String>): Category

    @PUT("admin/categories/{id}")
    suspend fun adminUpdateCategory(@Path("id") id: Long, @Body body: Map<String, String>): Category

    @DELETE("admin/categories/{id}")
    suspend fun adminDeleteCategory(@Path("id") id: Long)

    // Admin Tags
    @GET("admin/tags")
    suspend fun adminGetTags(
        @Query("page") page: Int = 0,
        @Query("size") size: Int = 100
    ): PageResponse<Tag>

    @POST("admin/tags")
    suspend fun adminCreateTag(@Body body: Map<String, String>): Tag

    @PUT("admin/tags/{id}")
    suspend fun adminUpdateTag(@Path("id") id: Long, @Body body: Map<String, String>): Tag

    @DELETE("admin/tags/{id}")
    suspend fun adminDeleteTag(@Path("id") id: Long)

    // Admin Comments
    @GET("admin/comments")
    suspend fun adminGetComments(
        @Query("page") page: Int = 0,
        @Query("size") size: Int = 10
    ): PageResponse<Comment>

    @PUT("admin/comments/{id}/toggle-visible")
    suspend fun adminToggleComment(@Path("id") id: Long): Comment

    @DELETE("admin/comments/{id}")
    suspend fun adminDeleteComment(@Path("id") id: Long)

    // Upload
    @Multipart
    @POST("admin/upload")
    suspend fun uploadImage(@Part file: MultipartBody.Part): UploadResponse
}
