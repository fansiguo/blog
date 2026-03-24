<template>
  <div class="pagination" v-if="totalPages > 1">
    <button :disabled="currentPage === 0" @click="$emit('change', currentPage - 1)">上一页</button>
    <span>{{ currentPage + 1 }} / {{ totalPages }}</span>
    <button :disabled="currentPage >= totalPages - 1" @click="$emit('change', currentPage + 1)">下一页</button>
  </div>
</template>

<script setup>
defineProps({ currentPage: Number, totalPages: Number })
defineEmits(['change'])
</script>

<style scoped>
.pagination { display: flex; align-items: center; justify-content: center; gap: 16px; margin-top: 20px; }
.pagination button { padding: 6px 16px; border: 1px solid #dcdfe6; background: #fff; border-radius: 4px; cursor: pointer; }
.pagination button:disabled { opacity: 0.5; cursor: not-allowed; }
.pagination button:not(:disabled):hover { border-color: #409eff; color: #409eff; }
</style>
