<template>
  <div class="pagination" v-if="totalPages > 1">
    <button class="page-btn" :disabled="currentPage === 0" @click="$emit('change', currentPage - 1)">
      &larr; 上一页
    </button>
    <div class="page-info">
      <span class="page-current">{{ currentPage + 1 }}</span>
      <span class="page-sep">/</span>
      <span class="page-total">{{ totalPages }}</span>
    </div>
    <button class="page-btn" :disabled="currentPage >= totalPages - 1" @click="$emit('change', currentPage + 1)">
      下一页 &rarr;
    </button>
  </div>
</template>

<script setup>
defineProps({ currentPage: Number, totalPages: Number })
defineEmits(['change'])
</script>

<style scoped>
.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
  margin-top: 48px;
  padding-top: 24px;
  border-top: 1px solid var(--color-border-light);
}
.page-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 8px 18px;
  border: 1px solid var(--color-border);
  background: var(--color-surface);
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  color: var(--color-text-secondary);
  transition: all 0.2s;
}
.page-btn:not(:disabled):hover { border-color: var(--color-navy); color: var(--color-navy); background: #f5f5f5; }
.page-btn:disabled { opacity: 0.35; cursor: not-allowed; }
.page-info { font-size: 14px; color: var(--color-text-muted); display: flex; align-items: center; gap: 4px; }
.page-current { font-weight: 600; color: var(--color-navy); }
.page-sep { color: var(--color-text-muted); }
</style>
