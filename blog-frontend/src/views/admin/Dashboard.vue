<template>
  <div class="admin-layout">
    <aside class="sidebar">
      <h3>管理后台</h3>
      <nav>
        <router-link to="/admin/articles">文章管理</router-link>
        <router-link to="/admin/categories">分类管理</router-link>
        <router-link to="/admin/tags">标签管理</router-link>
      </nav>
    </aside>
    <section class="admin-content">
      <router-view />
    </section>
  </div>
</template>

<style scoped>
.admin-layout { display: flex; gap: 20px; min-height: calc(100vh - 96px); }
.sidebar { width: 200px; background: #fff; border-radius: 8px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); flex-shrink: 0; }
.sidebar h3 { margin-bottom: 16px; font-size: 16px; }
.sidebar nav { display: flex; flex-direction: column; gap: 8px; }
.sidebar nav a { padding: 8px 12px; border-radius: 4px; color: #666; }
.sidebar nav a:hover { background: #f5f5f5; text-decoration: none; }
.sidebar nav a.router-link-active { background: #ecf5ff; color: #409eff; }
.admin-content { flex: 1; }
</style>
