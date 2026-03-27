package com.blog.android.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.blog.android.model.Tag
import com.blog.android.repository.ArticleRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AdminTagViewModel @Inject constructor(
    private val repository: ArticleRepository
) : ViewModel() {

    private val _tags = MutableStateFlow<List<Tag>>(emptyList())
    val tags: StateFlow<List<Tag>> = _tags

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage

    fun loadTags() {
        viewModelScope.launch {
            _isLoading.value = true
            try {
                _tags.value = repository.adminGetTags().content
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
            _isLoading.value = false
        }
    }

    fun createTag(name: String, onSuccess: () -> Unit) {
        viewModelScope.launch {
            try {
                repository.adminCreateTag(name)
                loadTags()
                onSuccess()
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
        }
    }

    fun updateTag(id: Long, name: String, onSuccess: () -> Unit) {
        viewModelScope.launch {
            try {
                repository.adminUpdateTag(id, name)
                loadTags()
                onSuccess()
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
        }
    }

    fun deleteTag(id: Long) {
        viewModelScope.launch {
            try {
                repository.adminDeleteTag(id)
                _tags.value = _tags.value.filter { it.id != id }
            } catch (e: Exception) {
                _errorMessage.value = e.message
            }
        }
    }
}
