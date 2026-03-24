<template>
  <div class="login-wrapper">
    <div class="card login-card">
      <h2>管理员登录</h2>
      <form @submit.prevent="handleLogin">
        <div class="form-item">
          <label>用户名</label>
          <input v-model="form.username" placeholder="请输入用户名" required />
        </div>
        <div class="form-item">
          <label>密码</label>
          <input v-model="form.password" type="password" placeholder="请输入密码" required />
        </div>
        <p v-if="error" class="error">{{ error }}</p>
        <button type="submit" class="btn btn-primary" style="width:100%">登录</button>
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

async function handleLogin() {
  try {
    error.value = ''
    const { data } = await api.post('/auth/login', form.value)
    localStorage.setItem('token', data.token)
    localStorage.setItem('nickname', data.nickname)
    router.push('/admin')
  } catch (e) {
    error.value = '用户名或密码错误'
  }
}
</script>

<style scoped>
.login-wrapper { display: flex; justify-content: center; padding-top: 80px; }
.login-card { width: 400px; }
.login-card h2 { margin-bottom: 24px; text-align: center; }
.form-item { margin-bottom: 16px; }
.form-item label { display: block; margin-bottom: 6px; font-size: 14px; color: #666; }
.error { color: #f56c6c; font-size: 13px; margin-bottom: 12px; }
</style>
