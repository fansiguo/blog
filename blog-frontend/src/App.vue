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
  --color-bg: #ffffff;
  --color-surface: #ffffff;
  --color-text: #333333;
  --color-text-secondary: #555555;
  --color-text-muted: #A9A7A7;
  --color-primary: #3546E5;
  --color-primary-hover: #2a38b8;
  --color-primary-light: #eef0ff;
  --color-accent: #ef5ba1;
  --color-navy: #070D4A;
  --color-success: #10b981;
  --color-warning: #f59e0b;
  --color-danger: #ef4444;
  --color-danger-hover: #dc2626;
  --color-border: #d0d0d0;
  --color-border-light: #e8e8e8;
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-md: 0 2px 4px rgba(0, 0, 0, 0.08);
  --shadow-lg: 0 4px 12px rgba(0, 0, 0, 0.1);
  --radius-sm: 4px;
  --radius-md: 6px;
  --radius-lg: 10px;
  --font-sans: 'Open Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-serif: 'Lora', Georgia, 'Noto Serif SC', serif;
  --font-mono: 'Inconsolata', 'Consolas', monospace;
  --max-width: 780px;
  --max-width-wide: 1100px;
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
a:hover { color: var(--color-primary-hover); text-decoration: underline; }

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

.btn-primary { background: var(--color-navy); color: #fff; }
.btn-primary:hover { background: #0a1266; color: #fff; text-decoration: none; }
.btn-danger { background: var(--color-danger); color: #fff; }
.btn-danger:hover { background: var(--color-danger-hover); color: #fff; }
.btn-success { background: var(--color-success); color: #fff; }
.btn-success:hover { opacity: 0.9; }
.btn-ghost { background: transparent; color: var(--color-text-secondary); border: 1px solid var(--color-border); }
.btn-ghost:hover { background: #f5f5f5; text-decoration: none; color: var(--color-text); }

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
  border-color: var(--color-navy);
  box-shadow: 0 0 0 2px rgba(7, 13, 74, 0.1);
}
input::placeholder, textarea::placeholder { color: var(--color-text-muted); }

table { width: 100%; border-collapse: collapse; background: var(--color-surface); overflow: hidden; }
th, td { padding: 12px 16px; text-align: left; }
th { font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; color: var(--color-text-secondary); border-bottom: 2px solid var(--color-navy); }
td { border-bottom: 1px solid var(--color-border-light); font-size: 14px; }
tr:last-child td { border-bottom: none; }
tr:hover td { background: #fafafa; }

.card {
  background: var(--color-surface);
  border-radius: var(--radius-md);
  padding: 28px;
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--color-border-light);
}

/* Page transitions */
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

/* Footer */
.site-footer {
  border-top: 2px solid var(--color-navy);
  padding: 32px 24px;
  text-align: center;
  background: #fafafa;
}
.site-footer p { color: var(--color-text-muted); font-size: 13px; }
</style>
