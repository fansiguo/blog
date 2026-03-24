<template>
  <div>
    <h1 class="page-title">最新文章</h1>
    <div v-if="articles.length === 0" class="empty">暂无文章</div>
    <article v-for="article in articles" :key="article.id" class="card article-card">
      <router-link :to="`/article/${article.id}`">
        <h2>{{ article.title }}</h2>
      </router-link>
      <div class="meta">
        <span v-if="article.category">{{ article.category.name }}</span>
        <span>{{ formatDate(article.createdAt) }}</span>
      </div>
      <p v-if="article.summary">{{ article.summary }}</p>
      <div v-if="article.tags?.length" class="tags">
        <span v-for="tag in article.tags" :key="tag.id" class="tag">{{ tag.name }}</span>
      </div>
    </article>
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
  return dt ? dt.substring(0, 10) : ''
}

async function loadArticles() {
  const { data } = await api.get('/articles', { params: { page: page.value, size: 10 } })
  articles.value = data.content
  totalPages.value = data.totalPages
}

onMounted(loadArticles)
</script>

<style scoped>
.page-title { margin-bottom: 20px; font-size: 24px; }
.article-card h2 { font-size: 20px; margin-bottom: 8px; }
.meta { color: #999; font-size: 13px; margin-bottom: 8px; display: flex; gap: 12px; }
.tags { display: flex; gap: 6px; margin-top: 8px; }
.tag { background: #ecf5ff; color: #409eff; padding: 2px 8px; border-radius: 3px; font-size: 12px; }
.empty { text-align: center; color: #999; padding: 40px; }
</style>
