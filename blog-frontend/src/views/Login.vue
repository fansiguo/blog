<template>
  <div class="login-wrapper">
    <div class="login-card">
      <div class="login-header">
        <div class="login-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
          </svg>
        </div>
        <h2>Welcome Back</h2>
        <p>登录管理后台</p>
      </div>
      <form @submit.prevent="handleLogin">
        <div class="form-item">
          <label>用户名</label>
          <input v-model="form.username" placeholder="请输入用户名" required autocomplete="username" />
        </div>
        <div class="form-item">
          <label>密码</label>
          <input v-model="form.password" type="password" placeholder="请输入密码" required autocomplete="current-password" />
        </div>
        <p v-if="error" class="error-msg">{{ error }}</p>
        <button type="submit" class="btn btn-primary login-btn" :disabled="loading">
          <span v-if="loading" class="btn-spinner"></span>
          {{ loading ? '登录中...' : '登录' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../api'

const router = useRouter()
const form = ref({ username: '', password: '' })
const error = ref('')
const loading = ref(false)

async function handleLogin() {
  try {
    error.value = ''
    loading.value = true
    const { data } = await api.post('/auth/login', form.value)
    localStorage.setItem('token', data.token)
    localStorage.setItem('nickname', data.nickname)
    router.push('/admin')
  } catch (e) {
    error.value = '用户名或密码错误'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 260px);
}
.login-card {
  width: 400px;
  background: var(--color-surface);
  border-radius: var(--radius-lg);
  padding: 40px;
  box-shadow: var(--shadow-lg);
  border: 1px solid var(--color-border-light);
}
.login-header {
  text-align: center;
  margin-bottom: 32px;
}
.login-icon {
  width: 56px;
  height: 56px;
  background: var(--color-primary-light);
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 16px;
  color: var(--color-primary);
}
.login-header h2 {
  font-size: 22px;
  font-weight: 700;
  margin-bottom: 4px;
}
.login-header p { color: var(--color-text-muted); font-size: 14px; }

.form-item { margin-bottom: 20px; }
.form-item label {
  display: block;
  margin-bottom: 6px;
  font-size: 13px;
  font-weight: 600;
  color: var(--color-text-secondary);
}
.form-item input { padding: 12px 14px; }

.error-msg {
  color: var(--color-danger);
  font-size: 13px;
  margin-bottom: 16px;
  padding: 10px 14px;
  background: #fef2f2;
  border-radius: var(--radius-sm);
  border: 1px solid #fecaca;
}

.login-btn {
  width: 100%;
  padding: 12px;
  font-size: 15px;
  font-weight: 600;
  margin-top: 4px;
}
.login-btn:disabled { opacity: 0.7; cursor: not-allowed; }

.btn-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255,255,255,0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
  margin-right: 6px;
}
@keyframes spin { to { transform: rotate(360deg); } }
</style>
