<template>
  <div>
    <div class="header mb-6">
      <div class="d-flex align-center">
        <a class="link-gray mr-4" @click="$router.go(-1)">
          <v-icon>mdi-arrow-left</v-icon>
        </a>
        <h1 class="text-h4">{{ director.name }}</h1>
      </div>
    </div>
    <div class="form-content d-flex align-start">
      <div>
        <div class="upload icon-button">
          <img v-if="director.image" :src="uploadsUrl + director.image" :alt="director.image">
          <v-icon v-else size="100" dark>mdi-account</v-icon>
        </div>
      </div>
      <div class="form">
        <div class="text-grey"><b>Rewards:</b> {{ director.rewards }}</div>
        <div v-if="director.bio" class="text-grey"><b>Biography:</b> {{ director.bio }}</div>
      </div>
    </div>
    <Movies :movies="movies" no-actions />
    <v-pagination
        v-if="pagination.last_page !== 1"
        v-model="pagination.current_page"
        :length="pagination.last_page"
        @update:model-value="getMovies"
    ></v-pagination>
  </div>
</template>

<script setup>
import { onMounted, ref} from "vue";
import axios from "axios";
import Validation from "@/composables/Validation";
import {useRoute, useRouter} from "vue-router";
import Movies from "@/components/Movies.vue";

const { handleErrors } = Validation()
const router = useRouter()
const route = useRoute()

const uploadsUrl = ref(import.meta.env.VITE_UPLOADS_URL)
const movies = ref([])
const pagination = ref({
  current_page: 1,
  first_page: 1,
  last_page: 1,
  per_page: 12,
  total: 1
})
const director = ref({
  name: '',
  rewards: '',
  bio: ''
})

async function getMovies() {
  try {
    const response = await axios.get('/movies/', {
      params: {
        page: pagination.value.current_page,
        limit: pagination.value.per_page,
        director: route.params.id
      }
    })
    movies.value = response.data.data
    pagination.value = response.data.meta
  } catch (error) { handleErrors(error) }
}

async function getData() {
  try {
    const response = await axios.get(`/directors/${route.params.id}`)

    director.value = response.data
  } catch (error) { handleErrors(error) }
}

onMounted(async () => {
  await getData()
  await getMovies()
})
</script>

<style lang="scss" scoped>
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 24px;

  .text-h4 {
    @media (max-width: 425px) {
      font-size: 28px !important;
    }
  }

  .v-btn {
    height: 42px;
    width: 150px;
  }
}

.form-content {
  @media (max-width: 767px) {
    flex-direction: column;
  }
}

.upload {
  width: 400px;
  height: 300px;
  background-color: #212121;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: default;
  overflow: hidden;

  @media (max-width: 1024px) {
    width: 300px;
    height: 225px;
  }

  @media (max-width: 767px) {
    width: 100%;
    height: calc(75vw - 48px);
  }

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.form {
  margin-left: 24px;
  flex: 1;

  @media (max-width: 767px) {
    width: 100%;
    margin-left: 0;
    margin-top: 24px;
  }
}
</style>