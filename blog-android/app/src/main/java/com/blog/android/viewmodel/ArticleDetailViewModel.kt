package com.blog.android.viewmodel

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.blog.android.model.Article
import com.blog.android.model.Comment
import com.blog.android.model.CommentRequest
import com.blog.android.repository.ArticleRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ArticleDetailViewModel @Inject constructor(
    private val repository: ArticleRepository,
    savedStateHandle: SavedStateHandle
) : ViewModel() {

    val articleId: Long = savedStateHandle.get<Long>("id") ?: 0L

    private val _article = MutableStateFlow<Article?>(null)
    val article: StateFlow<Article?> = _article

    private val _comments = MutableStateFlow<List<Comment>>(emptyList())
    val comments: StateFlow<List<Comment>> = _comments

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage

    private val _isSubmittingComment = MutableStateFlow(false)
    val isSubmittingComment: StateFlow<Boolean> = _isSubmittingComment

    private val _commentError = MutableStateFlow<String?>(null)
    val commentError: StateFlow<String?> = _commentError

    fun loadArticle() {
        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null
            try {
                _article.value = repository.getArticle(articleId)
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
            _isLoading.value = false
        }
    }

    fun loadComments(page: Int = 0) {
        viewModelScope.launch {
            try {
                val response = repository.getComments(articleId, page)
                _comments.value = response.content
            } catch (_: Exception) {
                // Silently fail for comments
            }
        }
    }

    fun submitComment(nickname: String, email: String?, content: String, onSuccess: () -> Unit) {
        viewModelScope.launch {
            _isSubmittingComment.value = true
            _commentError.value = null
            try {
                repository.postComment(articleId, CommentRequest(nickname, email, content))
                loadComments()
                onSuccess()
            } catch (e: Exception) {
                _commentError.value = e.message
            }
            _isSubmittingComment.value = false
        }
    }
}
