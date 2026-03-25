<template>
  <div :class="{ 'editor-fullscreen': isFullscreen }">
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
          <div class="gh-editor">
            <div class="gh-editor-header">
              <div class="gh-tabs">
                <button class="gh-tab" :class="{ active: editorMode === 'write' }" @click="editorMode = 'write'">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                  编写
                </button>
                <button class="gh-tab" :class="{ active: editorMode === 'preview' }" @click="editorMode = 'preview'">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                  预览
                </button>
              </div>
              <div class="gh-toolbar">
                <button class="gh-toolbar-btn" @click="insertMarkdown('bold')" title="粗体">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 4h8a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"/><path d="M6 12h9a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"/></svg>
                </button>
                <button class="gh-toolbar-btn" @click="insertMarkdown('italic')" title="斜体">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="4" x2="10" y2="4"/><line x1="14" y1="20" x2="5" y2="20"/><line x1="15" y1="4" x2="9" y2="20"/></svg>
                </button>
                <button class="gh-toolbar-btn" @click="insertMarkdown('heading')" title="标题">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 4v16"/><path d="M18 4v16"/><path d="M6 12h12"/></svg>
                </button>
                <span class="gh-toolbar-sep"></span>
                <button class="gh-toolbar-btn" @click="insertMarkdown('quote')" title="引用">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 21c3 0 7-1 7-8V5c0-1.25-.756-2.017-2-2H4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2 1 0 1 0 1 1v1c0 1-1 2-2 2s-1 .008-1 1.031V21z"/><path d="M15 21c3 0 7-1 7-8V5c0-1.25-.757-2.017-2-2h-4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2h.75c0 2.25.25 4-2.75 4v3z"/></svg>
                </button>
                <button class="gh-toolbar-btn" @click="insertMarkdown('code')" title="代码">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
                </button>
                <button class="gh-toolbar-btn" @click="insertMarkdown('link')" title="链接">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/></svg>
                </button>
                <button class="gh-toolbar-btn" @click="insertMarkdown('image')" title="图片">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                </button>
                <span class="gh-toolbar-sep"></span>
                <button class="gh-toolbar-btn" @click="insertMarkdown('ul')" title="无序列表">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
                </button>
                <button class="gh-toolbar-btn" @click="insertMarkdown('ol')" title="有序列表">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="10" y1="6" x2="21" y2="6"/><line x1="10" y1="12" x2="21" y2="12"/><line x1="10" y1="18" x2="21" y2="18"/><path d="M4 6h1v4"/><path d="M4 10h2"/><path d="M6 18H4c0-1 2-2 2-3s-1-1.5-2-1"/></svg>
                </button>
                <button class="gh-toolbar-btn" @click="insertMarkdown('table')" title="表格">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><line x1="3" y1="9" x2="21" y2="9"/><line x1="3" y1="15" x2="21" y2="15"/><line x1="9" y1="3" x2="9" y2="21"/><line x1="15" y1="3" x2="15" y2="21"/></svg>
                </button>
              </div>
            </div>
            <div class="gh-editor-body">
              <textarea
                v-show="editorMode === 'write'"
                ref="editorTextarea"
                v-model="form.content"
                placeholder="使用 Markdown 格式编写文章内容..."
                class="gh-textarea"
                @paste="handlePaste"
                @drop.prevent="handleDrop"
                @dragover.prevent
              ></textarea>
              <div v-show="editorMode === 'preview'" class="gh-preview article-content" v-html="renderedContent"></div>
            </div>
            <div class="gh-editor-footer">
              <label class="gh-upload-btn">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                上传图片
                <input type="file" accept="image/*" multiple hidden @change="handleFileUpload" />
              </label>
              <span class="gh-hint">支持 Markdown 格式 · 可粘贴或拖拽图片</span>
              <button class="gh-fullscreen-btn" @click="toggleFullscreen" :title="isFullscreen ? '退出全屏' : '全屏编辑'">
                <svg v-if="!isFullscreen" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 3 21 3 21 9"/><polyline points="9 21 3 21 3 15"/><line x1="21" y1="3" x2="14" y2="10"/><line x1="3" y1="21" x2="10" y2="14"/></svg>
                <svg v-else width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="4 14 10 14 10 20"/><polyline points="20 10 14 10 14 4"/><line x1="14" y1="10" x2="21" y2="3"/><line x1="3" y1="21" x2="10" y2="14"/></svg>
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="editor-sidebar" v-show="!isFullscreen">
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
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import MarkdownIt from 'markdown-it'
import api from '../../api'

const route = useRoute()
const router = useRouter()
const isEdit = computed(() => !!route.params.id)
const editorMode = ref('write')
const isFullscreen = ref(false)
const editorTextarea = ref(null)
const md = new MarkdownIt({ html: true, linkify: true, typographer: true, breaks: true })

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

const renderedContent = computed(() => {
  return form.value.content ? md.render(form.value.content) : '<p style="color: var(--color-text-muted)">暂无内容，请在编写模式中输入 Markdown 内容</p>'
})

function insertMarkdown(type) {
  editorMode.value = 'write'
  const textarea = editorTextarea.value
  if (!textarea) return
  const start = textarea.selectionStart
  const end = textarea.selectionEnd
  const selected = form.value.content.substring(start, end)
  let before = '', after = '', insert = ''

  switch (type) {
    case 'bold': before = '**'; after = '**'; insert = selected || '粗体文本'; break
    case 'italic': before = '*'; after = '*'; insert = selected || '斜体文本'; break
    case 'heading': before = '## '; insert = selected || '标题'; break
    case 'quote': before = '> '; insert = selected || '引用内容'; break
    case 'code': before = selected.includes('\n') ? '```\n' : '`'; after = selected.includes('\n') ? '\n```' : '`'; insert = selected || '代码'; break
    case 'link': before = '['; after = '](url)'; insert = selected || '链接文本'; break
    case 'image': before = '!['; after = '](url)'; insert = selected || '图片描述'; break
    case 'ul': before = '- '; insert = selected || '列表项'; break
    case 'ol': before = '1. '; insert = selected || '列表项'; break
    case 'table': insert = '| 列1 | 列2 | 列3 |\n| --- | --- | --- |\n| 内容 | 内容 | 内容 |'; break
  }

  const replacement = before + insert + after
  form.value.content = form.value.content.substring(0, start) + replacement + form.value.content.substring(end)
  nextTick(() => {
    textarea.focus()
    const cursorPos = start + before.length + insert.length
    textarea.setSelectionRange(start + before.length, cursorPos)
  })
}

function nextTick(fn) {
  setTimeout(fn, 0)
}

function toggleFullscreen() {
  isFullscreen.value = !isFullscreen.value
}

function handleEscape(e) {
  if (e.key === 'Escape' && isFullscreen.value) {
    isFullscreen.value = false
  }
}

async function uploadImage(file) {
  const formData = new FormData()
  formData.append('file', file)
  const { data } = await api.post('/admin/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
  return data.url
}

async function handleFileUpload(e) {
  const files = e.target.files
  if (!files.length) return
  for (const file of files) {
    const url = await uploadImage(file)
    insertImageUrl(url, file.name)
  }
  e.target.value = ''
}

async function handlePaste(e) {
  const items = e.clipboardData?.items
  if (!items) return
  for (const item of items) {
    if (item.type.startsWith('image/')) {
      e.preventDefault()
      const file = item.getAsFile()
      const url = await uploadImage(file)
      insertImageUrl(url, 'image')
      return
    }
  }
}

async function handleDrop(e) {
  const files = e.dataTransfer?.files
  if (!files) return
  for (const file of files) {
    if (file.type.startsWith('image/')) {
      const url = await uploadImage(file)
      insertImageUrl(url, file.name)
    }
  }
}

function insertImageUrl(url, name) {
  const textarea = editorTextarea.value
  const pos = textarea ? textarea.selectionStart : form.value.content.length
  const imgMd = `![${name}](${url})\n`
  form.value.content = form.value.content.substring(0, pos) + imgMd + form.value.content.substring(pos)
}

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

onMounted(() => {
  loadData()
  document.addEventListener('keydown', handleEscape)
})

onUnmounted(() => {
  document.removeEventListener('keydown', handleEscape)
})
</script>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}
.page-header h2 { font-size: 20px; font-weight: 700; }
.header-actions { display: flex; gap: 8px; }

.editor-layout { display: flex; gap: 24px; align-items: flex-start; }
.editor-main { flex: 1; min-width: 0; }
.editor-sidebar { width: 260px; flex-shrink: 0; position: sticky; top: 88px; }

.title-input {
  font-size: 22px;
  font-weight: 600;
  border: none;
  padding: 12px 0;
  border-bottom: 2px solid var(--color-border-light);
  border-radius: 0;
  background: transparent;
}
.title-input:focus { border-color: var(--color-primary); box-shadow: none; }
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
.summary-input:focus { border-color: var(--color-primary); box-shadow: none; }

.editor-wrapper { margin-top: 8px; }

/* GitHub-style editor */
.gh-editor {
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  background: var(--color-surface);
  overflow: hidden;
}

.gh-editor-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid var(--color-border-light);
  background: var(--color-border-light);
  padding: 0 12px;
}

.gh-tabs { display: flex; gap: 0; }
.gh-tab {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 10px 16px;
  font-size: 13px;
  font-weight: 500;
  color: var(--color-text-secondary);
  background: transparent;
  border: none;
  border-bottom: 2px solid transparent;
  cursor: pointer;
  transition: all 0.2s;
  margin-bottom: -1px;
}
.gh-tab:hover { color: var(--color-text); }
.gh-tab.active {
  color: var(--color-primary);
  border-bottom-color: var(--color-primary);
  background: var(--color-surface);
}

.gh-toolbar {
  display: flex;
  align-items: center;
  gap: 2px;
}
.gh-toolbar-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 30px;
  height: 30px;
  padding: 0;
  border: none;
  border-radius: var(--radius-sm);
  background: transparent;
  color: var(--color-text-secondary);
  cursor: pointer;
  transition: all 0.15s;
}
.gh-toolbar-btn:hover { background: var(--color-border); color: var(--color-text); }
.gh-toolbar-sep { width: 1px; height: 16px; background: var(--color-border); margin: 0 4px; }

.gh-editor-body { position: relative; }

.gh-textarea {
  width: 100%;
  min-height: 500px;
  padding: 16px;
  border: none;
  border-radius: 0;
  font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
  font-size: 14px;
  line-height: 1.7;
  resize: vertical;
  background: var(--color-surface);
  color: var(--color-text);
  tab-size: 2;
}
.gh-textarea:focus { outline: none; box-shadow: none; }

.gh-preview {
  min-height: 500px;
  padding: 16px;
  font-size: 15px;
  line-height: 1.8;
  overflow-y: auto;
}

.gh-editor-footer {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 12px;
  border-top: 1px solid var(--color-border-light);
  background: var(--color-border-light);
}

.gh-upload-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 10px;
  font-size: 12px;
  color: var(--color-text-secondary);
  cursor: pointer;
  border-radius: var(--radius-sm);
  transition: all 0.15s;
}
.gh-upload-btn:hover { background: var(--color-border); color: var(--color-text); }

.gh-hint { font-size: 12px; color: var(--color-text-muted); flex: 1; }

.gh-fullscreen-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  padding: 0;
  border: none;
  border-radius: var(--radius-sm);
  background: transparent;
  color: var(--color-text-secondary);
  cursor: pointer;
  transition: all 0.15s;
}
.gh-fullscreen-btn:hover { background: var(--color-border); color: var(--color-text); }

/* Fullscreen mode */
.editor-fullscreen {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 10000;
  background: var(--color-bg);
  padding: 20px 40px;
  overflow-y: auto;
}
.editor-fullscreen .editor-layout { max-width: 1000px; margin: 0 auto; }
.editor-fullscreen .gh-textarea { min-height: calc(100vh - 380px); }
.editor-fullscreen .gh-preview { min-height: calc(100vh - 380px); }

/* Sidebar */
.sidebar-section {
  background: var(--color-surface);
  border: 1px solid var(--color-border-light);
  border-radius: var(--radius-md);
  padding: 20px;
  margin-bottom: 16px;
}
.sidebar-section h4 {
  font-size: 13px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  color: var(--color-text-muted);
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
  border-radius: 20px;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
  color: var(--color-text-secondary);
}
.tag-checkbox input { display: none; }
.tag-checkbox:hover { border-color: var(--color-primary); }
.tag-checkbox.checked { background: var(--color-primary-light); border-color: var(--color-primary); color: var(--color-primary); font-weight: 500; }
.empty-hint { font-size: 13px; color: var(--color-text-muted); }
</style>
