<template>
  <div v-if="article" class="article-page">
    <header class="article-header">
      <div class="article-meta">
        <time class="article-date">{{ formatDate(article.createdAt) }}</time>
        <span v-if="article.category" class="article-category">{{ article.category.name }}</span>
      </div>
      <h1 class="article-title">{{ article.title }}</h1>
      <div v-if="article.tags?.length" class="article-tags">
        <span v-for="tag in article.tags" :key="tag.id" class="tag">{{ tag.name }}</span>
      </div>
      <div class="title-line"></div>
    </header>
    <div class="article-content" v-html="renderedContent"></div>
    <footer class="article-footer">
      <router-link to="/" class="back-link">
        &larr; 返回文章列表
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
}

.article-meta {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 16px;
  font-size: 13px;
}
.article-category {
  color: var(--color-navy);
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  font-size: 12px;
}
.article-date { color: var(--color-text-muted); }

.article-title {
  font-family: var(--font-serif);
  font-size: 36px;
  font-weight: 700;
  line-height: 1.3;
  letter-spacing: -0.5px;
  margin-bottom: 16px;
  color: var(--color-navy);
}

.article-tags { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 20px; }
.tag {
  color: var(--color-text-muted);
  font-size: 12px;
  font-weight: 500;
  padding: 2px 10px;
  border: 1px solid var(--color-border-light);
  border-radius: 2px;
}

.title-line {
  width: 60px;
  height: 3px;
  background: var(--color-accent);
}

.article-content {
  font-size: 16px;
  line-height: 1.8;
  color: var(--color-text);
}
.article-content :deep(h1) { font-family: var(--font-serif); font-size: 28px; font-weight: 700; margin: 48px 0 20px; color: var(--color-navy); }
.article-content :deep(h2) { font-family: var(--font-serif); font-size: 24px; font-weight: 700; margin: 40px 0 16px; color: var(--color-navy); border-bottom: 1px solid var(--color-border-light); padding-bottom: 8px; }
.article-content :deep(h3) { font-family: var(--font-serif); font-size: 20px; font-weight: 600; margin: 32px 0 12px; color: var(--color-navy); }
.article-content :deep(p) { margin-bottom: 20px; }
.article-content :deep(blockquote) {
  border-left: 3px solid var(--color-navy);
  padding: 12px 20px;
  margin: 24px 0;
  background: #f8f8f8;
  color: var(--color-text-secondary);
  font-style: italic;
}
.article-content :deep(pre) {
  background: #2d2d2d;
  color: #e0e0e0;
  padding: 20px 24px;
  border-radius: var(--radius-sm);
  overflow-x: auto;
  margin: 24px 0;
  font-size: 14px;
  line-height: 1.6;
  font-family: var(--font-mono);
}
.article-content :deep(code) {
  background: #f0f0f0;
  padding: 2px 6px;
  border-radius: 2px;
  font-size: 14px;
  font-family: var(--font-mono);
  color: var(--color-navy);
}
.article-content :deep(pre code) { background: transparent; padding: 0; color: inherit; }
.article-content :deep(img) { max-width: 100%; margin: 24px 0; border: 1px solid var(--color-border-light); }
.article-content :deep(ul), .article-content :deep(ol) { padding-left: 24px; margin-bottom: 20px; }
.article-content :deep(li) { margin-bottom: 6px; }
.article-content :deep(hr) { border: none; border-top: 1px solid var(--color-border); margin: 40px 0; }
.article-content :deep(a) { color: var(--color-primary); text-decoration: underline; text-underline-offset: 3px; }
.article-content :deep(table) { overflow: hidden; margin: 24px 0; border: 1px solid var(--color-border-light); }

.article-footer {
  margin-top: 48px;
  padding-top: 24px;
  border-top: 2px solid var(--color-navy);
}
.back-link {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: var(--color-primary);
  font-size: 14px;
  font-weight: 500;
  transition: color 0.2s;
}
.back-link:hover { color: var(--color-navy); }

.loading { text-align: center; padding: 80px 20px; color: var(--color-text-muted); }
.loading-spinner {
  width: 32px;
  height: 32px;
  border: 3px solid var(--color-border);
  border-top-color: var(--color-navy);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin: 0 auto 16px;
}
@keyframes spin { to { transform: rotate(360deg); } }
</style>
