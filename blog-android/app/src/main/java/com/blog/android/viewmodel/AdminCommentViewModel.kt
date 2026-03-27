package com.blog.android.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.blog.android.model.Comment
import com.blog.android.repository.ArticleRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AdminCommentViewModel @Inject constructor(
    private val repository: ArticleRepository
) : ViewModel() {

    private val _comments = MutableStateFlow<List<Comment>>(emptyList())
    val comments: StateFlow<List<Comment>> = _comments

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage

    private val _currentPage = MutableStateFlow(0)
    val currentPage: StateFlow<Int> = _currentPage

    private val _totalPages = MutableStateFlow(0)
    val totalPages: StateFlow<Int> = _totalPages

    fun loadComments(page: Int = 0) {
        viewModelScope.launch {
            _isLoading.value = true
            try {
                val response = repository.adminGetComments(page)
                _comments.value = response.content
                _currentPage.value = response.number
                _totalPages.value = response.totalPages
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
            _isLoading.value = false
        }
    }

    fun toggleVisible(id: Long) {
        viewModelScope.launch {
            try {
                val updated = repository.adminToggleComment(id)
                _comments.value = _comments.value.map { if (it.id == id) updated else it }
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
        }
    }

    fun deleteComment(id: Long) {
        viewModelScope.launch {
            try {
                repository.adminDeleteComment(id)
                _comments.value = _comments.value.filter { it.id != id }
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
        }
    }

    fun nextPage() {
        if (_currentPage.value + 1 < _totalPages.value) loadComments(_currentPage.value + 1)
    }

    fun previousPage() {
        if (_currentPage.value > 0) loadComments(_currentPage.value - 1)
    }
}
