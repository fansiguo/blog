<template>
  <div>
    <div class="header">
      <h2>文章管理</h2>
      <router-link to="/admin/articles/new" class="btn btn-primary">新建文章</router-link>
    </div>
    <table>
      <thead>
        <tr>
          <th>标题</th>
          <th>分类</th>
          <th>状态</th>
          <th>创建时间</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="article in articles" :key="article.id">
          <td>{{ article.title }}</td>
          <td>{{ article.category?.name || '-' }}</td>
          <td>
            <span :class="article.status === 'PUBLISHED' ? 'status-pub' : 'status-draft'">
              {{ article.status === 'PUBLISHED' ? '已发布' : '草稿' }}
            </span>
          </td>
          <td>{{ article.createdAt?.substring(0, 10) }}</td>
          <td>
            <router-link :to="`/admin/articles/${article.id}/edit`" class="btn btn-primary" style="margin-right:8px">编辑</router-link>
            <button class="btn btn-danger" @click="handleDelete(article.id)">删除</button>
          </td>
        </tr>
      </tbody>
    </table>
    <Pagination :currentPage="page" :totalPages="totalPages" @change="page = $event; loadArticles()" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../../api'
import Pagination from '../../components/Pagination.vue'

const articles = ref([])
const page = ref(0)
const totalPages = ref(0)

async function loadArticles() {
  const { data } = await api.get('/admin/articles', { params: { page: page.value, size: 10 } })
  articles.value = data.content
  totalPages.value = data.totalPages
}

async function handleDelete(id) {
  if (!confirm('确定删除这篇文章吗？')) return
  await api.delete(`/admin/articles/${id}`)
  loadArticles()
}

onMounted(loadArticles)
</script>

<style scoped>
.header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.status-pub { color: #67c23a; }
.status-draft { color: #e6a23c; }
</style>
