<template>
  <div>
    <header class="page-header">
      <h1>最新文章</h1>
      <p class="page-subtitle">思考、记录与分享</p>
    </header>

    <div v-if="articles.length === 0" class="empty-state">
      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="empty-icon">
        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>
      </svg>
      <p>暂无文章</p>
    </div>

    <div class="article-list">
      <article v-for="article in articles" :key="article.id" class="article-card">
        <router-link :to="`/article/${article.id}`" class="article-link">
          <div class="article-body">
            <div class="article-meta">
              <span v-if="article.category" class="article-category">{{ article.category.name }}</span>
              <time class="article-date">{{ formatDate(article.createdAt) }}</time>
            </div>
            <h2 class="article-title">{{ article.title }}</h2>
            <p v-if="article.summary" class="article-summary">{{ article.summary }}</p>
            <div v-if="article.tags?.length" class="article-tags">
              <span v-for="tag in article.tags" :key="tag.id" class="tag"># {{ tag.name }}</span>
            </div>
            <span class="read-more">阅读全文 &rarr;</span>
          </div>
        </router-link>
      </article>
    </div>

    <Pagination :currentPage="page" :totalPages="totalPages" @change="page = $event; loadArticles()" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../api'
import Pagination from '../components/Pagination.vue'

const articles = ref([])
const page = ref(0)
const totalPages = ref(0)

function formatDate(dt) {
  if (!dt) return ''
  const d = new Date(dt)
  return d.toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric' })
}

async function loadArticles() {
  const { data } = await api.get('/articles', { params: { page: page.value, size: 10 } })
  articles.value = data.content
  totalPages.value = data.totalPages
}

onMounted(loadArticles)
</script>

<style scoped>
.page-header { margin-bottom: 48px; }
.page-header h1 {
  font-family: var(--font-serif);
  font-size: 36px;
  font-weight: 700;
  letter-spacing: -0.5px;
  margin-bottom: 8px;
}
.page-subtitle { color: var(--color-text-muted); font-size: 16px; }

.empty-state { text-align: center; padding: 80px 20px; color: var(--color-text-muted); }
.empty-icon { margin-bottom: 16px; opacity: 0.4; }
.empty-state p { font-size: 15px; }

.article-list { display: flex; flex-direction: column; gap: 1px; }

.article-card {
  background: var(--color-surface);
  border-radius: var(--radius-md);
  border: 1px solid var(--color-border-light);
  overflow: hidden;
  transition: all 0.3s ease;
  margin-bottom: 16px;
}
.article-card:hover {
  box-shadow: var(--shadow-lg);
  border-color: var(--color-border);
  transform: translateY(-2px);
}

.article-link { display: block; text-decoration: none; color: inherit; }
.article-link:hover { text-decoration: none; color: inherit; }

.article-body { padding: 28px 32px; }

.article-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
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
  font-size: 22px;
  font-weight: 700;
  line-height: 1.4;
  margin-bottom: 10px;
  color: var(--color-text);
  transition: color 0.2s;
}
.article-card:hover .article-title { color: var(--color-primary); }

.article-summary {
  color: var(--color-text-secondary);
  font-size: 15px;
  line-height: 1.7;
  margin-bottom: 14px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.article-tags { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 14px; }
.tag {
  color: var(--color-text-muted);
  font-size: 13px;
  font-weight: 500;
}

.read-more {
  font-size: 14px;
  font-weight: 500;
  color: var(--color-primary);
  opacity: 0;
  transition: opacity 0.3s;
}
.article-card:hover .read-more { opacity: 1; }
</style>
