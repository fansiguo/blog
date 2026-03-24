<template>
  <div>
    <h2>标签管理</h2>
    <div class="add-form card">
      <input v-model="newName" placeholder="新标签名称" style="flex:1" @keyup.enter="handleAdd" />
      <button class="btn btn-primary" @click="handleAdd">添加</button>
    </div>
    <table>
      <thead>
        <tr>
          <th>名称</th>
          <th>创建时间</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in tags" :key="item.id">
          <td>
            <input v-if="editId === item.id" v-model="editName" @keyup.enter="handleUpdate(item.id)" />
            <span v-else>{{ item.name }}</span>
          </td>
          <td>{{ item.createdAt?.substring(0, 10) }}</td>
          <td>
            <template v-if="editId === item.id">
              <button class="btn btn-success" @click="handleUpdate(item.id)" style="margin-right:8px">保存</button>
              <button class="btn" @click="editId = null">取消</button>
            </template>
            <template v-else>
              <button class="btn btn-primary" @click="startEdit(item)" style="margin-right:8px">编辑</button>
              <button class="btn btn-danger" @click="handleDelete(item.id)">删除</button>
            </template>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../../api'

const tags = ref([])
const newName = ref('')
const editId = ref(null)
const editName = ref('')

async function loadTags() {
  const { data } = await api.get('/tags')
  tags.value = data
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
.add-form { display: flex; gap: 12px; margin: 16px 0; }
</style>
