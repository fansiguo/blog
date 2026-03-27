package com.blog.android.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.blog.android.model.Category
import com.blog.android.repository.ArticleRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AdminCategoryViewModel @Inject constructor(
    private val repository: ArticleRepository
) : ViewModel() {

    private val _categories = MutableStateFlow<List<Category>>(emptyList())
    val categories: StateFlow<List<Category>> = _categories

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage

    fun loadCategories() {
        viewModelScope.launch {
            _isLoading.value = true
            try {
                _categories.value = repository.adminGetCategories().content
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
            _isLoading.value = false
        }
    }

    fun createCategory(name: String, onSuccess: () -> Unit) {
        viewModelScope.launch {
            try {
                repository.adminCreateCategory(name)
                loadCategories()
                onSuccess()
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
        }
    }

    fun updateCategory(id: Long, name: String, onSuccess: () -> Unit) {
        viewModelScope.launch {
            try {
                repository.adminUpdateCategory(id, name)
                loadCategories()
                onSuccess()
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
        }
    }

    fun deleteCategory(id: Long) {
        viewModelScope.launch {
            try {
                repository.adminDeleteCategory(id)
                _categories.value = _categories.value.filter { it.id != id }
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
        }
    }
}
