<template>
  <div>
    <div class="page-header">
      <h2>标签管理</h2>
    </div>

    <div class="add-bar">
      <input v-model="newName" placeholder="输入标签名称后按 Enter 添加" @keyup.enter="handleAdd" />
      <button class="btn btn-primary" @click="handleAdd">添加</button>
    </div>

    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>名称</th>
            <th>创建时间</th>
            <th style="width: 160px">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in tags" :key="item.id">
            <td>
              <input v-if="editId === item.id" v-model="editName" @keyup.enter="handleUpdate(item.id)" class="inline-edit" />
              <span v-else class="item-name">{{ item.name }}</span>
            </td>
            <td class="text-muted">{{ item.createdAt?.substring(0, 10) }}</td>
            <td>
              <div class="action-btns">
                <template v-if="editId === item.id">
                  <button class="btn btn-primary btn-sm" @click="handleUpdate(item.id)">保存</button>
                  <button class="btn btn-ghost btn-sm" @click="editId = null">取消</button>
                </template>
                <template v-else>
                  <button class="btn btn-ghost btn-sm" @click="startEdit(item)">编辑</button>
                  <button class="btn btn-ghost btn-sm btn-delete" @click="handleDelete(item.id)">删除</button>
                </template>
              </div>
            </td>
          </tr>
          <tr v-if="tags.length === 0">
            <td colspan="3" class="empty-row">暂无标签</td>
          </tr>
        </tbody>
      </table>
    </div>

    <Pagination :currentPage="page" :totalPages="totalPages" @change="page = $event; loadTags()" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../../api'
import Pagination from '../../components/Pagination.vue'

const tags = ref([])
const page = ref(0)
const totalPages = ref(0)
const newName = ref('')
const editId = ref(null)
const editName = ref('')

async function loadTags() {
  const { data } = await api.get('/admin/tags', { params: { page: page.value, size: 10 } })
  tags.value = data.content || data || []
  const pg = data.page || data
  totalPages.value = pg.totalPages || 0
}

async function handleAdd() {
  if (!newName.value.trim()) return
  await api.post('/admin/tags', { name: newName.value.trim() })
  newName.value = ''
  loadTags()
}

function startEdit(item) {
  editId.value = item.id
  editName.value = item.name
}

async function handleUpdate(id) {
  await api.put(`/admin/tags/${id}`, { name: editName.value.trim() })
  editId.value = null
  loadTags()
}

async function handleDelete(id) {
  if (!confirm('确定删除？')) return
  await api.delete(`/admin/tags/${id}`)
  loadTags()
}

onMounted(loadTags)
</script>

<style scoped>
.page-header { margin-bottom: 24px; }
.page-header h2 { font-size: 20px; font-weight: 700; }

.add-bar {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}
.add-bar input { flex: 1; }

.table-wrapper {
  border-radius: var(--radius-md);
  overflow: hidden;
  border: 1px solid var(--color-border-light);
}

.item-name { font-weight: 500; }
.text-muted { color: var(--color-text-muted); font-size: 13px; }
.inline-edit { width: 200px; padding: 6px 10px; font-size: 14px; }

.action-btns { display: flex; gap: 6px; }
.btn-sm { padding: 5px 12px; font-size: 13px; }
.btn-delete:hover { color: var(--color-danger); border-color: var(--color-danger); }

.empty-row { text-align: center; color: var(--color-text-muted); padding: 48px 0 !important; }
</style>
