package com.blog.android.viewmodel

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.blog.android.config.AppConfig
import com.blog.android.model.*
import com.blog.android.repository.ArticleRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AdminArticleEditViewModel @Inject constructor(
    private val repository: ArticleRepository,
    savedStateHandle: SavedStateHandle
) : ViewModel() {

    val articleId: Long? = savedStateHandle.get<Long>("id")

    val title = MutableStateFlow("")
    val content = MutableStateFlow("")
    val summary = MutableStateFlow("")
    val coverImage = MutableStateFlow<String?>(null)
    val status = MutableStateFlow(ArticleStatus.DRAFT)
    val selectedCategoryId = MutableStateFlow<Long?>(null)
    val selectedTagIds = MutableStateFlow<Set<Long>>(emptySet())

    private val _categories = MutableStateFlow<List<Category>>(emptyList())
    val categories: StateFlow<List<Category>> = _categories

    private val _tags = MutableStateFlow<List<Tag>>(emptyList())
    val tags: StateFlow<List<Tag>> = _tags

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading

    private val _isSaving = MutableStateFlow(false)
    val isSaving: StateFlow<Boolean> = _isSaving

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage

    val isPreviewMode = MutableStateFlow(false)

    fun loadData() {
        viewModelScope.launch {
            _isLoading.value = true
            try {
                val catResponse = repository.adminGetCategories()
                _categories.value = catResponse.content
                val tagResponse = repository.adminGetTags()
                _tags.value = tagResponse.content
            } catch (_: Exception) {}

            articleId?.let { id ->
                try {
                    val article = repository.adminGetArticle(id)
                    title.value = article.title
                    content.value = article.content ?: ""
                    summary.value = article.summary ?: ""
                    coverImage.value = article.coverImage
                    status.value = article.status
                    selectedCategoryId.value = article.category?.id
                    selectedTagIds.value = article.tags.map { it.id }.toSet()
                } catch (e: Exception) {
                    _errorMessage.value = e.message
                }
            }
            _isLoading.value = false
        }
    }

    fun save(onSuccess: () -> Unit) {
        viewModelScope.launch {
            _isSaving.value = true
            _errorMessage.value = null
            val request = ArticleRequest(
                title = title.value,
                content = content.value,
                summary = summary.value,
                coverImage = coverImage.value,
                status = status.value,
                categoryId = selectedCategoryId.value,
                tagIds = selectedTagIds.value.toList()
            )
            try {
                if (articleId != null) {
                    repository.adminUpdateArticle(articleId, request)
                } else {
                    repository.adminCreateArticle(request)
                }
                onSuccess()
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
            _isSaving.value = false
        }
    }

    fun uploadImage(imageData: ByteArray, filename: String, mimeType: String) {
        viewModelScope.launch {
            try {
                val response = repository.uploadImage(imageData, filename, mimeType)
                val imageUrl = AppConfig.BASE_URL + response.url
                content.value += "\n![image]($imageUrl)\n"
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
        }
    }

    fun toggleTag(tagId: Long) {
        val current = selectedTagIds.value.toMutableSet()
        if (current.contains(tagId)) current.remove(tagId) else current.add(tagId)
        selectedTagIds.value = current
    }
}
