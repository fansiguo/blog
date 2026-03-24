<template>
  <div>
    <h2>{{ isEdit ? '编辑文章' : '新建文章' }}</h2>
    <div class="card" style="margin-top:16px">
      <div class="form-item">
        <label>标题</label>
        <input v-model="form.title" placeholder="文章标题" />
      </div>
      <div class="form-row">
        <div class="form-item" style="flex:1">
          <label>分类</label>
          <select v-model="form.categoryId">
            <option :value="null">无分类</option>
            <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
          </select>
        </div>
        <div class="form-item" style="flex:1">
          <label>状态</label>
          <select v-model="form.status">
            <option value="DRAFT">草稿</option>
            <option value="PUBLISHED">发布</option>
          </select>
        </div>
      </div>
      <div class="form-item">
        <label>标签</label>
        <div class="tag-select">
          <label v-for="tag in tags" :key="tag.id" class="tag-option">
            <input type="checkbox" :value="tag.id" v-model="form.tagIds" />
            {{ tag.name }}
          </label>
        </div>
      </div>
      <div class="form-item">
        <label>摘要</label>
        <textarea v-model="form.summary" rows="2" placeholder="文章摘要"></textarea>
      </div>
      <div class="form-item">
        <label>正文 (Markdown)</label>
        <MdEditor v-model="form.content" language="zh-CN" style="height: 500px" />
      </div>
      <div style="margin-top:16px; display:flex; gap:12px">
        <button class="btn btn-primary" @click="handleSave">保存</button>
        <router-link to="/admin/articles" class="btn">返回</router-link>
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
.form-item { margin-bottom: 16px; }
.form-item label { display: block; margin-bottom: 6px; font-size: 14px; color: #666; }
.form-row { display: flex; gap: 16px; }
.tag-select { display: flex; flex-wrap: wrap; gap: 12px; }
.tag-option { display: flex; align-items: center; gap: 4px; font-size: 14px; cursor: pointer; }
.tag-option input { width: auto; }
</style>
