<template>
  <nav class="navbar">
    <div class="navbar-inner">
      <router-link to="/" class="logo">
        <span class="logo-text">Blog</span>
      </router-link>
      <div class="nav-links">
        <router-link to="/" class="nav-link">首页</router-link>
        <template v-if="isLoggedIn">
          <router-link to="/admin" class="nav-link">管理</router-link>
          <div class="nav-divider"></div>
          <span class="nav-user">{{ nickname }}</span>
          <button class="btn-logout" @click="logout">退出</button>
        </template>
        <router-link v-else to="/login" class="nav-link">登录</router-link>
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
.navbar {
  background: var(--color-navy);
  border-bottom: 3px solid var(--color-accent);
  position: sticky;
  top: 0;
  z-index: 100;
}
.navbar-inner {
  max-width: var(--max-width-wide);
  margin: 0 auto;
  padding: 0 24px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.logo {
  display: flex;
  align-items: center;
  color: #fff;
  font-weight: 700;
  font-size: 22px;
  font-family: var(--font-serif);
  letter-spacing: -0.5px;
}
.logo:hover { text-decoration: none; color: #fff; }
.logo-text { color: #fff; }
.nav-links { display: flex; align-items: center; gap: 4px; }
.nav-link {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  border-radius: var(--radius-sm);
  color: rgba(255, 255, 255, 0.8);
  font-size: 14px;
  font-weight: 500;
  transition: all 0.2s;
}
.nav-link:hover { color: #fff; text-decoration: none; background: rgba(255, 255, 255, 0.1); }
.nav-link.router-link-active { color: #fff; background: rgba(255, 255, 255, 0.15); }
.nav-divider { width: 1px; height: 20px; background: rgba(255, 255, 255, 0.25); margin: 0 8px; }
.nav-user { color: rgba(255, 255, 255, 0.7); font-size: 13px; font-weight: 500; padding: 0 8px; }
.btn-logout {
  padding: 5px 14px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  background: transparent;
  border-radius: var(--radius-sm);
  color: rgba(255, 255, 255, 0.8);
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}
.btn-logout:hover { border-color: var(--color-accent); color: var(--color-accent); background: rgba(239, 91, 161, 0.1); }
</style>
