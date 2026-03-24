<template>
  <div id="app">
    <Navbar />
    <main class="container">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import Navbar from './components/Navbar.vue'
</script>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f5f5f5; color: #333; }
.container { max-width: 960px; margin: 0 auto; padding: 20px; }
a { color: #409eff; text-decoration: none; }
a:hover { text-decoration: underline; }
button, .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
.btn-primary { background: #409eff; color: #fff; }
.btn-primary:hover { background: #337ecc; }
.btn-danger { background: #f56c6c; color: #fff; }
.btn-danger:hover { background: #dd6161; }
.btn-success { background: #67c23a; color: #fff; }
.btn-success:hover { background: #529b2e; }
input, select, textarea { padding: 8px 12px; border: 1px solid #dcdfe6; border-radius: 4px; font-size: 14px; width: 100%; }
input:focus, select:focus, textarea:focus { outline: none; border-color: #409eff; }
table { width: 100%; border-collapse: collapse; background: #fff; }
th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ebeef5; }
th { background: #fafafa; font-weight: 600; }
.card { background: #fff; border-radius: 8px; padding: 20px; margin-bottom: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
</style>
