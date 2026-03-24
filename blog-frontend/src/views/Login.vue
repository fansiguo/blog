<template>
  <div class="login-wrapper">
    <div class="login-card">
      <div class="login-header">
        <h2>管理后台</h2>
        <div class="header-accent"></div>
        <p>请输入管理员凭据</p>
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
  padding: 40px;
  border-top: 3px solid var(--color-navy);
  box-shadow: var(--shadow-md);
}
.login-card::before {
  content: '';
  display: block;
  width: 0;
}
.login-header {
  text-align: center;
  margin-bottom: 32px;
}
.login-header h2 {
  font-family: var(--font-serif);
  font-size: 24px;
  font-weight: 700;
  color: var(--color-navy);
  margin-bottom: 8px;
}
.header-accent {
  width: 40px;
  height: 3px;
  background: var(--color-accent);
  margin: 0 auto 12px;
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
  border-left: 3px solid var(--color-danger);
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
