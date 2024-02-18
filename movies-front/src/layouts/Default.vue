<template>
  <div class="layout">
    <Header />
    <div class="content">
      <slot />
    </div>
  </div>
</template>

<script setup>
import Header from '../components/Header.vue'
</script>

<style lang="scss" scoped>
.layout {
  width: 100%;
}

.content {
  width: 100%;
  padding-top: 24px;
  padding-bottom: 24px;
}
</style>