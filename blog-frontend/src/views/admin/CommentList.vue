<template>
  <div>
    <div class="page-header">
      <h2>留言管理</h2>
    </div>

    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>文章</th>
            <th>昵称</th>
            <th>内容</th>
            <th>时间</th>
            <th>状态</th>
            <th style="width: 160px">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in comments" :key="item.id" :class="{ 'row-hidden': !item.visible }">
            <td class="comment-article">{{ item.articleTitle || '-' }}</td>
            <td class="comment-nickname">{{ item.nickname }}</td>
            <td class="comment-content">{{ item.content }}</td>
            <td class="text-muted">{{ item.createdAt?.substring(0, 10) }}</td>
            <td>
              <span :class="['status-badge', item.visible ? 'status-visible' : 'status-hidden']">
                {{ item.visible ? '展示中' : '已隐藏' }}
              </span>
            </td>
            <td>
              <div class="action-btns">
                <button class="btn btn-ghost btn-sm" @click="handleToggle(item.id)">
                  {{ item.visible ? '隐藏' : '展示' }}
                </button>
                <button class="btn btn-ghost btn-sm btn-delete" @click="handleDelete(item.id)">删除</button>
              </div>
            </td>
          </tr>
          <tr v-if="comments.length === 0">
            <td colspan="6" class="empty-row">暂无留言</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../../api'

const comments = ref([])

async function loadComments() {
  const { data } = await api.get('/admin/comments')
  comments.value = data
}

async function handleToggle(id) {
  await api.put(`/admin/comments/${id}/toggle-visible`)
  loadComments()
}

async function handleDelete(id) {
  if (!confirm('确定删除该留言？')) return
  await api.delete(`/admin/comments/${id}`)
  loadComments()
}

onMounted(loadComments)
</script>

<style scoped>
.page-header { margin-bottom: 24px; }
.page-header h2 { font-size: 20px; font-weight: 700; }

.table-wrapper {
  border-radius: var(--radius-md);
  overflow: hidden;
  border: 1px solid var(--color-border-light);
}

.comment-article { max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-weight: 500; }
.comment-nickname { white-space: nowrap; }
.comment-content { max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.text-muted { color: var(--color-text-muted); font-size: 13px; }

.status-badge {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 12px;
  font-weight: 500;
}
.status-visible { background: #dcfce7; color: #166534; }
.status-hidden { background: #fee2e2; color: #991b1b; }

.row-hidden { opacity: 0.6; }

.action-btns { display: flex; gap: 6px; }
.btn-sm { padding: 5px 12px; font-size: 13px; }
.btn-delete:hover { color: var(--color-danger); border-color: var(--color-danger); }

.empty-row { text-align: center; color: var(--color-text-muted); padding: 48px 0 !important; }
</style>
