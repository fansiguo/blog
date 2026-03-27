package com.blog.android.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.blog.android.model.LoginRequest
import com.blog.android.repository.ArticleRepository
import com.blog.android.security.TokenManager
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AuthViewModel @Inject constructor(
    private val repository: ArticleRepository,
    private val tokenManager: TokenManager
) : ViewModel() {

    private val _isLoggedIn = MutableStateFlow(tokenManager.isLoggedIn())
    val isLoggedIn: StateFlow<Boolean> = _isLoggedIn

    private val _nickname = MutableStateFlow(tokenManager.getNickname() ?: "")
    val nickname: StateFlow<String> = _nickname

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage

    fun login(username: String, password: String) {
        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null
            try {
                val response = repository.login(LoginRequest(username, password))
                tokenManager.saveToken(response.token)
                tokenManager.saveNickname(response.nickname)
                _nickname.value = response.nickname
                _isLoggedIn.value = true
            } catch (e: Exception) {
                _errorMessage.value = "登录失败: ${e.message}"
            }
            _isLoading.value = false
        }
    }

    fun logout() {
        tokenManager.clearAll()
        _isLoggedIn.value = false
        _nickname.value = ""
    }
}
