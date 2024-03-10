<template>
  <div>
    <div class="filter">
      <v-select
        v-model="filters.types"
        density="compact"
        variant="outlined"
        item-value="id"
        item-title="name"
        clearable
        multiple
        hide-details
        label="Type"
        :items="types"
      ></v-select>
      <v-select
        v-model="filters.genres"
        density="compact"
        variant="outlined"
        item-value="id"
        item-title="name"
        clearable
        multiple
        hide-details
        label="Genre"
        :items="genres"
      ></v-select>
      <v-select
        v-model="filters.companies"
        density="compact"
        variant="outlined"
        item-value="id"
        item-title="name"
        clearable
        multiple
        hide-details
        label="Company"
        :items="companies"
      ></v-select>
      <v-select
        v-model="filters.year"
        density="compact"
        variant="outlined"
        clearable
        hide-details
        label="Year"
        :items="years"
      ></v-select>
      <v-select
        v-model="filters.countries"
        density="compact"
        variant="outlined"
        item-value="code"
        item-title="name"
        clearable
        multiple
        hide-details
        label="Country"
        :items="countries"
      ></v-select>
      <div class="btn-wrapper">
        <v-btn variant="outlined" color="primary" @click="getMovies">Search</v-btn>
      </div>
    </div>
    <Movies :movies="items" @update:list="getMovies" />
    <v-pagination
        v-if="pagination.last_page !== 1"
        v-model="pagination.current_page"
        :length="pagination.last_page"
        @update:model-value="getMovies"
    ></v-pagination>
  </div>
</template>

<script setup>
import {onMounted, ref, shallowRef, watch} from 'vue'
import Movies from '@/components/Movies.vue'
import axios from "axios";
import Validation from "@/composables/Validation";
import countries from '@/entities/countries'
import {useRoute} from "vue-router";

const { handleErrors } = Validation()
const route = useRoute()

const types = shallowRef([])
const genres = shallowRef([])
const companies = shallowRef([])
const years = shallowRef([])
const items = shallowRef([])
const pagination = ref({
  current_page: 1,
  first_page: 1,
  last_page: 1,
  per_page: 12,
  total: 1
})
const filters = ref({
  types: [],
  genres: [],
  companies: [],
  year: null,
  countries: []
})

async function getMovies() {
  try {
    const response = await axios.get('/movies/', {
      params: {
        page: pagination.value.current_page,
        limit: pagination.value.per_page,
        search: route.query.search,
        ...filters.value
      }
    })
    items.value = response.data.data
    pagination.value = response.data.meta
    years.value = response.data.meta.years
  } catch (error) { handleErrors(error) }
}

async function getList(apiRoute) {
  try {
    const response = await axios.get(apiRoute)
    return response.data
  } catch (error) {
    handleErrors(error)
    return []
  }
}

onMounted(async () => {
  getMovies()
  companies.value = await getList('/companies/')
  genres.value = await getList('/genres/')
  types.value = await getList('/types/')
})

watch(() => route, () => {
  getMovies()
}, { deep: true })
</script>

<style lang="scss" scoped>
.filter {
  display: flex;
  align-items: center;
  justify-content: space-between;

  @media (max-width: 1120px) {
    gap: 10px;
    flex-wrap: wrap;
  }

  .v-select {
    margin-right: 10px;

    &--multiple {
      :deep(.v-field__input) {
        flex-wrap: nowrap;

        .v-select__selection:not(:first-child) {
          display: none;
        }

        .v-select__selection-comma {
          color: rgba(0, 0, 0, 0);
          &:before {
            color: rgba(235, 235, 235, 0.64);
            letter-spacing: -.8px;
            content: "...";
          }
        }
      }
    }
  }

  .v-select, .btn-wrapper {
    width: 20%;

    @media (max-width: 1120px) {
      margin-right: 0;
      width: calc(33% - 5px);
    }

    @media (max-width: 600px) {
      width: calc(50% - 5px);
    }

    @media (max-width: 430px) {
      width: calc(100%);
    }
  }

  .v-btn {
    height: 42px;
    width: 100%;
  }
}
</style>