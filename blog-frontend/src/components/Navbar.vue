<template>
  <nav class="navbar">
    <div class="navbar-inner">
      <router-link to="/" class="logo">Blog</router-link>
      <div class="nav-links">
        <router-link to="/">首页</router-link>
        <template v-if="isLoggedIn">
          <router-link to="/admin">管理后台</router-link>
          <span class="nickname">{{ nickname }}</span>
          <button class="btn btn-danger" @click="logout">退出</button>
        </template>
        <router-link v-else to="/login">登录</router-link>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const isLoggedIn = computed(() => !!localStorage.getItem('token'))
const nickname = computed(() => localStorage.getItem('nickname') || '')

function logout() {
  localStorage.removeItem('token')
  localStorage.removeItem('nickname')
  router.push('/')
  location.reload()
}
</script>

<style scoped>
.navbar { background: #fff; box-shadow: 0 1px 3px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 100; }
.navbar-inner { max-width: 960px; margin: 0 auto; padding: 0 20px; height: 56px; display: flex; align-items: center; justify-content: space-between; }
.logo { font-size: 20px; font-weight: 700; color: #333; }
.logo:hover { text-decoration: none; }
.nav-links { display: flex; align-items: center; gap: 16px; }
.nav-links a { color: #666; }
.nav-links a.router-link-active { color: #409eff; }
.nickname { color: #999; font-size: 14px; }
</style>
