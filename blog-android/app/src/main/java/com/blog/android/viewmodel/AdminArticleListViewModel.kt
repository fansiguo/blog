package com.blog.android.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.blog.android.model.Article
import com.blog.android.repository.ArticleRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AdminArticleListViewModel @Inject constructor(
    private val repository: ArticleRepository
) : ViewModel() {

    private val _articles = MutableStateFlow<List<Article>>(emptyList())
    val articles: StateFlow<List<Article>> = _articles

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage

    private val _currentPage = MutableStateFlow(0)
    val currentPage: StateFlow<Int> = _currentPage

    private val _totalPages = MutableStateFlow(0)
    val totalPages: StateFlow<Int> = _totalPages

    fun loadArticles(page: Int = 0) {
        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null
            try {
                val response = repository.adminGetArticles(page)
                _articles.value = response.content
                _currentPage.value = response.number
                _totalPages.value = response.totalPages
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
            _isLoading.value = false
        }
    }

    fun deleteArticle(id: Long) {
        viewModelScope.launch {
            try {
                repository.adminDeleteArticle(id)
                _articles.value = _articles.value.filter { it.id != id }
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
        }
    }

    fun nextPage() {
        if (_currentPage.value + 1 < _totalPages.value) loadArticles(_currentPage.value + 1)
    }

    fun previousPage() {
        if (_currentPage.value > 0) loadArticles(_currentPage.value - 1)
    }
}
