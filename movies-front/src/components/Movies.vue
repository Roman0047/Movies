<template>
  <div class="movies">
    <Movie
        v-for="movie in movies"
        :key="movie.id"
        :movie="movie"
        :no-actions="noActions"
        @update:list="$emit('update:list')"
    />
  </div>
</template>

<script setup>
import Movie from '@/components/Movie.vue'

defineProps({
  movies: {
    type: Array,
    default: () => []
  },
  noActions: {
    type: Boolean,
    default: false
  }
})

defineEmits(['update:list'])
</script>

<style lang="scss" scoped>
.movies {
  display: flex;
  flex-wrap: wrap;
  margin-top: 24px;
  width: calc(100% + 0.76%);

  @media (max-width: 1120px) {
    width: calc(100% + 1.52%);
  }

  @media (max-width: 600px) {
    width: calc(100% + 3%);
  }

  @media (max-width: 430px) {
    width: calc(100%);
  }
}
</style>