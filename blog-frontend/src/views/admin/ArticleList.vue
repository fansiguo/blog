<template>
  <div>
    <div class="page-header">
      <h2>文章管理</h2>
      <router-link to="/admin/articles/new" class="btn btn-primary">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        新建文章
      </router-link>
    </div>

    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>标题</th>
            <th>分类</th>
            <th>状态</th>
            <th>创建时间</th>
            <th style="width: 160px">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="article in articles" :key="article.id">
            <td class="title-cell">{{ article.title }}</td>
            <td><span class="category-badge" v-if="article.category">{{ article.category.name }}</span><span v-else class="text-muted">-</span></td>
            <td>
              <span class="status-badge" :class="article.status === 'PUBLISHED' ? 'status-pub' : 'status-draft'">
                {{ article.status === 'PUBLISHED' ? '已发布' : '草稿' }}
              </span>
            </td>
            <td class="text-muted">{{ article.createdAt?.substring(0, 10) }}</td>
            <td>
              <div class="action-btns">
                <router-link :to="`/admin/articles/${article.id}/edit`" class="btn btn-ghost btn-sm">编辑</router-link>
                <button class="btn btn-ghost btn-sm btn-delete" @click="handleDelete(article.id)">删除</button>
              </div>
            </td>
          </tr>
          <tr v-if="articles.length === 0">
            <td colspan="5" class="empty-row">暂无文章，点击右上角创建</td>
          </tr>
        </tbody>
      </table>
    </div>

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
  articles.value = data.content || data || []
  const pg = data.page || data
  totalPages.value = pg.totalPages || 0
}

async function handleDelete(id) {
  if (!confirm('确定删除这篇文章吗？')) return
  await api.delete(`/admin/articles/${id}`)
  loadArticles()
}

onMounted(loadArticles)
</script>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}
.page-header h2 { font-size: 20px; font-weight: 700; }

.table-wrapper {
  border-radius: var(--radius-md);
  overflow: hidden;
  border: 1px solid var(--color-border-light);
}

.title-cell { font-weight: 500; }
.text-muted { color: var(--color-text-muted); font-size: 13px; }

.category-badge {
  display: inline-block;
  padding: 2px 10px;
  background: var(--color-border-light);
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
  color: var(--color-text-secondary);
}

.status-badge {
  display: inline-block;
  padding: 3px 10px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
}
.status-pub { background: #ecfdf5; color: #059669; }
.status-draft { background: #fffbeb; color: #d97706; }

.action-btns { display: flex; gap: 6px; }
.btn-sm { padding: 5px 12px; font-size: 13px; }
.btn-delete:hover { color: var(--color-danger); border-color: var(--color-danger); }

.empty-row { text-align: center; color: var(--color-text-muted); padding: 48px 0 !important; }
</style>
