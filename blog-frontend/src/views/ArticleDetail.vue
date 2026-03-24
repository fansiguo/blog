<template>
  <div v-if="article" class="card article-detail">
    <h1>{{ article.title }}</h1>
    <div class="meta">
      <span v-if="article.category">{{ article.category.name }}</span>
      <span>{{ formatDate(article.createdAt) }}</span>
    </div>
    <div v-if="article.tags?.length" class="tags">
      <span v-for="tag in article.tags" :key="tag.id" class="tag">{{ tag.name }}</span>
    </div>
    <div class="content" v-html="renderedContent"></div>
  </div>
  <div v-else class="empty">加载中...</div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import MarkdownIt from 'markdown-it'
import api from '../api'

const route = useRoute()
const article = ref(null)
const md = new MarkdownIt()

const renderedContent = computed(() => {
  return article.value?.content ? md.render(article.value.content) : ''
})

function formatDate(dt) {
  return dt ? dt.substring(0, 10) : ''
}

onMounted(async () => {
  const { data } = await api.get(`/articles/${route.params.id}`)
  article.value = data
})
</script>

<style scoped>
.article-detail h1 { font-size: 28px; margin-bottom: 12px; }
.meta { color: #999; font-size: 13px; margin-bottom: 12px; display: flex; gap: 12px; }
.tags { display: flex; gap: 6px; margin-bottom: 20px; }
.tag { background: #ecf5ff; color: #409eff; padding: 2px 8px; border-radius: 3px; font-size: 12px; }
.content { line-height: 1.8; margin-top: 20px; }
.content :deep(pre) { background: #f5f5f5; padding: 16px; border-radius: 4px; overflow-x: auto; }
.content :deep(code) { background: #f5f5f5; padding: 2px 4px; border-radius: 3px; font-size: 14px; }
.content :deep(img) { max-width: 100%; }
.empty { text-align: center; color: #999; padding: 40px; }
</style>
