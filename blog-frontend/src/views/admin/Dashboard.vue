<template>
  <div class="admin-layout">
    <aside class="sidebar">
      <div class="sidebar-header">
        <h3>管理后台</h3>
      </div>
      <nav class="sidebar-nav">
        <router-link to="/admin/articles" class="sidebar-link">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
          文章管理
        </router-link>
        <router-link to="/admin/categories" class="sidebar-link">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg>
          分类管理
        </router-link>
        <router-link to="/admin/tags" class="sidebar-link">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/><line x1="7" y1="7" x2="7.01" y2="7"/></svg>
          标签管理
        </router-link>
      </nav>
    </aside>
    <section class="admin-content">
      <router-view />
    </section>
  </div>
</template>

<style scoped>
.admin-layout {
  display: flex;
  gap: 32px;
  min-height: calc(100vh - 180px);
  max-width: var(--max-width-wide);
  margin: 0 auto;
}
.sidebar {
  width: 200px;
  flex-shrink: 0;
  position: sticky;
  top: 88px;
  align-self: flex-start;
}
.sidebar-header {
  margin-bottom: 8px;
  padding-bottom: 8px;
  border-bottom: 2px solid var(--color-navy);
}
.sidebar-header h3 {
  font-family: var(--font-serif);
  font-size: 14px;
  font-weight: 700;
  color: var(--color-navy);
}
.sidebar-nav { display: flex; flex-direction: column; gap: 2px; }
.sidebar-link {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 9px 12px;
  border-radius: var(--radius-sm);
  color: var(--color-text-secondary);
  font-size: 14px;
  font-weight: 500;
  transition: all 0.2s;
  border-left: 3px solid transparent;
}
.sidebar-link:hover { color: var(--color-navy); text-decoration: none; background: #f5f5f5; border-left-color: var(--color-accent); }
.sidebar-link.router-link-active {
  background: var(--color-navy);
  color: #fff;
  border-left-color: var(--color-accent);
}
.admin-content { flex: 1; min-width: 0; }
</style>
