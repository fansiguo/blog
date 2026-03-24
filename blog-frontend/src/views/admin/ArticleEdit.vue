<template>
  <div>
    <div class="page-header">
      <h2>{{ isEdit ? '编辑文章' : '新建文章' }}</h2>
      <div class="header-actions">
        <router-link to="/admin/articles" class="btn btn-ghost">取消</router-link>
        <button class="btn btn-primary" @click="handleSave">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
          保存
        </button>
      </div>
    </div>

    <div class="editor-layout">
      <div class="editor-main">
        <div class="form-item">
          <input v-model="form.title" placeholder="输入文章标题..." class="title-input" />
        </div>
        <div class="form-item">
          <textarea v-model="form.summary" rows="2" placeholder="输入文章摘要（可选）" class="summary-input"></textarea>
        </div>
        <div class="form-item editor-wrapper">
          <MdEditor v-model="form.content" language="zh-CN" :onUploadImg="onUploadImg" style="height: 520px; overflow: hidden;" />
        </div>
      </div>

      <div class="editor-sidebar">
        <div class="sidebar-section">
          <h4>发布设置</h4>
          <div class="form-item">
            <label>状态</label>
            <select v-model="form.status">
              <option value="DRAFT">草稿</option>
              <option value="PUBLISHED">发布</option>
            </select>
          </div>
          <div class="form-item">
            <label>分类</label>
            <select v-model="form.categoryId">
              <option :value="null">无分类</option>
              <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
            </select>
          </div>
        </div>

        <div class="sidebar-section">
          <h4>标签</h4>
          <div class="tag-grid">
            <label v-for="tag in tags" :key="tag.id" class="tag-checkbox" :class="{ checked: form.tagIds.includes(tag.id) }">
              <input type="checkbox" :value="tag.id" v-model="form.tagIds" />
              {{ tag.name }}
            </label>
          </div>
          <p v-if="tags.length === 0" class="empty-hint">暂无标签，请先在标签管理中创建</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { MdEditor } from 'md-editor-v3'
import 'md-editor-v3/lib/style.css'
import api from '../../api'

const route = useRoute()
const router = useRouter()
const isEdit = computed(() => !!route.params.id)
const categories = ref([])
const tags = ref([])
const form = ref({
  title: '',
  content: '',
  summary: '',
  coverImage: '',
  status: 'DRAFT',
  categoryId: null,
  tagIds: []
})

async function loadData() {
  const [catRes, tagRes] = await Promise.all([
    api.get('/categories'),
    api.get('/tags')
  ])
  categories.value = catRes.data
  tags.value = tagRes.data

  if (isEdit.value) {
    const { data } = await api.get(`/admin/articles/${route.params.id}`)
    form.value = {
      title: data.title,
      content: data.content || '',
      summary: data.summary || '',
      coverImage: data.coverImage || '',
      status: data.status,
      categoryId: data.category?.id || null,
      tagIds: data.tags?.map(t => t.id) || []
    }
  }
}

async function onUploadImg(files, callback) {
  const urls = []
  for (const file of files) {
    const formData = new FormData()
    formData.append('file', file)
    const { data } = await api.post('/admin/upload', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    urls.push(data.url)
  }
  callback(urls)
}

async function handleSave() {
  if (!form.value.title.trim()) {
    alert('请输入标题')
    return
  }
  const payload = { ...form.value, tagIds: form.value.tagIds.length ? form.value.tagIds : null }
  if (isEdit.value) {
    await api.put(`/admin/articles/${route.params.id}`, payload)
  } else {
    await api.post('/admin/articles', payload)
  }
  router.push('/admin/articles')
}

onMounted(loadData)
</script>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 12px;
  border-bottom: 2px solid var(--color-navy);
}
.page-header h2 { font-family: var(--font-serif); font-size: 20px; font-weight: 700; color: var(--color-navy); }
.header-actions { display: flex; gap: 8px; }

.editor-layout { display: flex; gap: 24px; align-items: flex-start; }
.editor-main { flex: 1; min-width: 0; }
.editor-sidebar { width: 260px; flex-shrink: 0; position: sticky; top: 88px; }

.title-input {
  font-family: var(--font-serif);
  font-size: 22px;
  font-weight: 600;
  border: none;
  padding: 12px 0;
  border-bottom: 2px solid var(--color-border-light);
  border-radius: 0;
  background: transparent;
  color: var(--color-navy);
}
.title-input:focus { border-color: var(--color-navy); box-shadow: none; }
.summary-input {
  border: none;
  padding: 10px 0;
  border-bottom: 1px solid var(--color-border-light);
  border-radius: 0;
  background: transparent;
  resize: none;
  font-size: 14px;
  color: var(--color-text-secondary);
}
.summary-input:focus { border-color: var(--color-navy); box-shadow: none; }

.editor-wrapper { margin-top: 8px; }

.sidebar-section {
  background: var(--color-surface);
  border: 1px solid var(--color-border-light);
  border-top: 3px solid var(--color-navy);
  padding: 20px;
  margin-bottom: 16px;
}
.sidebar-section h4 {
  font-family: var(--font-serif);
  font-size: 13px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  color: var(--color-navy);
  margin-bottom: 14px;
}
.form-item { margin-bottom: 14px; }
.form-item:last-child { margin-bottom: 0; }
.form-item label {
  display: block;
  margin-bottom: 6px;
  font-size: 13px;
  font-weight: 500;
  color: var(--color-text-secondary);
}

.tag-grid { display: flex; flex-wrap: wrap; gap: 6px; }
.tag-checkbox {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 4px 12px;
  border: 1px solid var(--color-border);
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
  color: var(--color-text-secondary);
}
.tag-checkbox input { display: none; }
.tag-checkbox:hover { border-color: var(--color-navy); }
.tag-checkbox.checked { background: var(--color-navy); border-color: var(--color-navy); color: #fff; font-weight: 500; }
.empty-hint { font-size: 13px; color: var(--color-text-muted); }
</style>
