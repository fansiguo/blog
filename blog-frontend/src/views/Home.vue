<template>
  <div>
    <header class="page-header">
      <h1>Latest Posts</h1>
      <div class="header-line"></div>
    </header>

    <div v-if="articles.length === 0" class="empty-state">
      <p>暂无文章</p>
    </div>

    <div class="article-list">
      <article v-for="article in articles" :key="article.id" class="article-card">
        <router-link :to="`/article/${article.id}`" class="article-link">
          <div class="article-body">
            <div class="article-meta">
              <time class="article-date">{{ formatDate(article.createdAt) }}</time>
              <span v-if="article.category" class="article-category">{{ article.category.name }}</span>
            </div>
            <h2 class="article-title">{{ article.title }}</h2>
            <p v-if="article.summary" class="article-summary">{{ article.summary }}</p>
            <div v-if="article.tags?.length" class="article-tags">
              <span v-for="tag in article.tags" :key="tag.id" class="tag">{{ tag.name }}</span>
            </div>
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
.page-header { margin-bottom: 40px; }
.page-header h1 {
  font-family: var(--font-serif);
  font-size: 32px;
  font-weight: 700;
  color: var(--color-navy);
  margin-bottom: 12px;
}
.header-line {
  width: 60px;
  height: 3px;
  background: var(--color-accent);
}

.empty-state { text-align: center; padding: 80px 20px; color: var(--color-text-muted); }
.empty-state p { font-size: 15px; }

.article-list { display: flex; flex-direction: column; gap: 0; }

.article-card {
  position: relative;
  border-top: 3px solid var(--color-navy);
  background: var(--color-surface);
  margin-bottom: 24px;
  transition: box-shadow 0.2s ease;
}
.article-card::before {
  content: '';
  position: absolute;
  top: -3px;
  right: 0;
  width: 3px;
  height: calc(100% + 3px);
  background: var(--color-accent);
}
.article-card:hover {
  box-shadow: var(--shadow-md);
}

.article-link { display: block; text-decoration: none; color: inherit; }
.article-link:hover { text-decoration: none; color: inherit; }

.article-body { padding: 24px 28px; }

.article-meta {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 10px;
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
  font-size: 22px;
  font-weight: 700;
  line-height: 1.4;
  margin-bottom: 10px;
  color: var(--color-navy);
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

.article-tags { display: flex; flex-wrap: wrap; gap: 8px; }
.tag {
  color: var(--color-text-muted);
  font-size: 12px;
  font-weight: 500;
  padding: 2px 10px;
  border: 1px solid var(--color-border-light);
  border-radius: 2px;
}
</style>
