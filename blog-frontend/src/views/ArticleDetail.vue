<template>
  <div v-if="article" class="article-page">
    <header class="article-header">
      <div class="article-meta">
        <span v-if="article.category" class="article-category">{{ article.category.name }}</span>
        <time class="article-date">{{ formatDate(article.createdAt) }}</time>
      </div>
      <h1 class="article-title">{{ article.title }}</h1>
      <div v-if="article.tags?.length" class="article-tags">
        <span v-for="tag in article.tags" :key="tag.id" class="tag"># {{ tag.name }}</span>
      </div>
    </header>
    <div class="article-content" v-html="renderedContent"></div>
    <footer class="article-footer">
      <router-link to="/" class="back-link">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
        返回文章列表
      </router-link>
    </footer>
  </div>

  <div v-else class="loading">
    <div class="loading-spinner"></div>
    <p>加载中...</p>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import MarkdownIt from 'markdown-it'
import api from '../api'

const route = useRoute()
const article = ref(null)
const md = new MarkdownIt({ html: true, linkify: true, typographer: true })

const renderedContent = computed(() => {
  return article.value?.content ? md.render(article.value.content) : ''
})

function formatDate(dt) {
  if (!dt) return ''
  const d = new Date(dt)
  return d.toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric' })
}

onMounted(async () => {
  const { data } = await api.get(`/articles/${route.params.id}`)
  article.value = data
  document.title = data.title + ' - Blog'
})
</script>

<style scoped>
.article-page { max-width: 100%; }

.article-header {
  margin-bottom: 40px;
  padding-bottom: 32px;
  border-bottom: 1px solid var(--color-border-light);
}

.article-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
  font-size: 13px;
}
.article-category {
  color: var(--color-primary);
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  font-size: 12px;
}
.article-date { color: var(--color-text-muted); }

.article-title {
  font-family: var(--font-serif);
  font-size: 34px;
  font-weight: 700;
  line-height: 1.3;
  letter-spacing: -0.5px;
  margin-bottom: 16px;
}

.article-tags { display: flex; flex-wrap: wrap; gap: 10px; }
.tag { color: var(--color-text-muted); font-size: 14px; font-weight: 500; }

.article-content {
  font-size: 16px;
  line-height: 1.9;
  color: var(--color-text);
}
.article-content :deep(h1) { font-family: var(--font-serif); font-size: 28px; font-weight: 700; margin: 48px 0 20px; letter-spacing: -0.3px; }
.article-content :deep(h2) { font-family: var(--font-serif); font-size: 24px; font-weight: 700; margin: 40px 0 16px; letter-spacing: -0.3px; }
.article-content :deep(h3) { font-family: var(--font-serif); font-size: 20px; font-weight: 600; margin: 32px 0 12px; }
.article-content :deep(p) { margin-bottom: 20px; }
.article-content :deep(blockquote) {
  border-left: 3px solid var(--color-primary);
  padding: 16px 20px;
  margin: 24px 0;
  background: var(--color-primary-light);
  border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
  color: var(--color-text-secondary);
  font-style: italic;
}
.article-content :deep(pre) {
  background: #1e293b;
  color: #e2e8f0;
  padding: 20px 24px;
  border-radius: var(--radius-md);
  overflow-x: auto;
  margin: 24px 0;
  font-size: 14px;
  line-height: 1.7;
}
.article-content :deep(code) {
  background: var(--color-border-light);
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 14px;
  color: var(--color-danger);
}
.article-content :deep(pre code) { background: transparent; padding: 0; color: inherit; }
.article-content :deep(img) { max-width: 100%; border-radius: var(--radius-md); margin: 24px 0; }
.article-content :deep(ul), .article-content :deep(ol) { padding-left: 24px; margin-bottom: 20px; }
.article-content :deep(li) { margin-bottom: 8px; }
.article-content :deep(hr) { border: none; border-top: 1px solid var(--color-border); margin: 40px 0; }
.article-content :deep(a) { color: var(--color-primary); text-decoration: underline; text-underline-offset: 3px; }
.article-content :deep(table) { border-radius: var(--radius-sm); overflow: hidden; margin: 24px 0; }

.article-footer {
  margin-top: 48px;
  padding-top: 24px;
  border-top: 1px solid var(--color-border-light);
}
.back-link {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: var(--color-text-secondary);
  font-size: 14px;
  font-weight: 500;
  transition: color 0.2s;
}
.back-link:hover { color: var(--color-primary); }

.loading { text-align: center; padding: 80px 20px; color: var(--color-text-muted); }
.loading-spinner {
  width: 32px;
  height: 32px;
  border: 3px solid var(--color-border);
  border-top-color: var(--color-primary);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin: 0 auto 16px;
}
@keyframes spin { to { transform: rotate(360deg); } }
</style>
