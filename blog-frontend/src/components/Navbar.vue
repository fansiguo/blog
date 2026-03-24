<template>
  <nav class="navbar">
    <div class="navbar-inner">
      <router-link to="/" class="logo">
        <span class="logo-icon">B</span>
        <span class="logo-text">Blog</span>
      </router-link>
      <div class="nav-links">
        <router-link to="/" class="nav-link">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
          首页
        </router-link>
        <template v-if="isLoggedIn">
          <router-link to="/admin" class="nav-link">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
            管理
          </router-link>
          <div class="nav-divider"></div>
          <span class="nav-user">{{ nickname }}</span>
          <button class="btn-logout" @click="logout">退出</button>
        </template>
        <router-link v-else to="/login" class="nav-link">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg>
          登录
        </router-link>
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
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border-bottom: 1px solid var(--color-border);
  position: sticky;
  top: 0;
  z-index: 100;
}
.navbar-inner {
  max-width: var(--max-width-wide);
  margin: 0 auto;
  padding: 0 24px;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.logo {
  display: flex;
  align-items: center;
  gap: 10px;
  color: var(--color-text);
  font-weight: 700;
  font-size: 18px;
}
.logo:hover { text-decoration: none; }
.logo-icon {
  width: 32px;
  height: 32px;
  background: linear-gradient(135deg, var(--color-primary), var(--color-accent));
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 16px;
  font-weight: 700;
}
.logo-text { letter-spacing: -0.5px; }
.nav-links { display: flex; align-items: center; gap: 4px; }
.nav-link {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 14px;
  border-radius: var(--radius-sm);
  color: var(--color-text-secondary);
  font-size: 14px;
  font-weight: 500;
  transition: all 0.2s;
}
.nav-link:hover { background: var(--color-border-light); color: var(--color-text); text-decoration: none; }
.nav-link.router-link-active { color: var(--color-primary); background: var(--color-primary-light); }
.nav-divider { width: 1px; height: 20px; background: var(--color-border); margin: 0 8px; }
.nav-user { color: var(--color-text-secondary); font-size: 13px; font-weight: 500; padding: 0 8px; }
.btn-logout {
  padding: 6px 14px;
  border: 1px solid var(--color-border);
  background: transparent;
  border-radius: var(--radius-sm);
  color: var(--color-text-secondary);
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}
.btn-logout:hover { border-color: var(--color-danger); color: var(--color-danger); background: #fef2f2; }
</style>
