<template>
  <div id="app">
    <Navbar />
    <main class="main-content" :class="{ 'main-wide': $route.meta.wide }">
      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </main>
    <footer class="site-footer">
      <div class="footer-inner">
        <p>&copy; {{ new Date().getFullYear() }} Blog. Powered by Spring Boot & Vue.</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import Navbar from './components/Navbar.vue'
</script>

<style>
:root {
  --color-bg: #fafafa;
  --color-surface: #ffffff;
  --color-text: #1a1a2e;
  --color-text-secondary: #6b7280;
  --color-text-muted: #9ca3af;
  --color-primary: #2563eb;
  --color-primary-hover: #1d4ed8;
  --color-primary-light: #eff6ff;
  --color-accent: #8b5cf6;
  --color-success: #10b981;
  --color-warning: #f59e0b;
  --color-danger: #ef4444;
  --color-danger-hover: #dc2626;
  --color-border: #e5e7eb;
  --color-border-light: #f3f4f6;
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.04);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.06), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.08), 0 4px 6px -4px rgba(0, 0, 0, 0.04);
  --radius-sm: 6px;
  --radius-md: 10px;
  --radius-lg: 16px;
  --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-serif: 'Noto Serif SC', Georgia, serif;
  --max-width: 780px;
  --max-width-wide: 1200px;
}

* { margin: 0; padding: 0; box-sizing: border-box; }

body {
  font-family: var(--font-sans);
  background: var(--color-bg);
  color: var(--color-text);
  line-height: 1.6;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.main-content {
  max-width: var(--max-width);
  margin: 0 auto;
  padding: 40px 24px 80px;
  min-height: calc(100vh - 180px);
}
.main-wide { max-width: var(--max-width-wide); }

a { color: var(--color-primary); text-decoration: none; transition: color 0.2s; }
a:hover { color: var(--color-primary-hover); }

button, .btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 8px 18px;
  border: none;
  border-radius: var(--radius-sm);
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  font-family: var(--font-sans);
  transition: all 0.2s ease;
  gap: 6px;
  text-decoration: none;
}
button:active, .btn:active { transform: scale(0.97); }

.btn-primary { background: var(--color-primary); color: #fff; }
.btn-primary:hover { background: var(--color-primary-hover); color: #fff; text-decoration: none; }
.btn-danger { background: var(--color-danger); color: #fff; }
.btn-danger:hover { background: var(--color-danger-hover); color: #fff; }
.btn-success { background: var(--color-success); color: #fff; }
.btn-success:hover { opacity: 0.9; }
.btn-ghost { background: transparent; color: var(--color-text-secondary); border: 1px solid var(--color-border); }
.btn-ghost:hover { background: var(--color-border-light); text-decoration: none; color: var(--color-text); }

input, select, textarea {
  padding: 10px 14px;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  font-size: 14px;
  font-family: var(--font-sans);
  width: 100%;
  transition: border-color 0.2s, box-shadow 0.2s;
  background: var(--color-surface);
  color: var(--color-text);
}
input:focus, select:focus, textarea:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}
input::placeholder, textarea::placeholder { color: var(--color-text-muted); }

table { width: 100%; border-collapse: collapse; background: var(--color-surface); border-radius: var(--radius-md); overflow: hidden; box-shadow: var(--shadow-sm); }
th, td { padding: 14px 18px; text-align: left; }
th { background: var(--color-border-light); font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; color: var(--color-text-secondary); border-bottom: 1px solid var(--color-border); }
td { border-bottom: 1px solid var(--color-border-light); font-size: 14px; }
tr:last-child td { border-bottom: none; }
tr:hover td { background: var(--color-border-light); }

.card {
  background: var(--color-surface);
  border-radius: var(--radius-md);
  padding: 28px;
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--color-border-light);
  transition: box-shadow 0.3s ease;
}

/* Page transitions */
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

/* Footer */
.site-footer { border-top: 1px solid var(--color-border); padding: 32px 24px; text-align: center; }
.site-footer p { color: var(--color-text-muted); font-size: 13px; }
</style>
