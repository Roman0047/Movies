<template>
  <div class="movie">
    <div class="d-flex align-center justify-space-between position-relative mb-6">
      <h1 class="text-h4 movie-title">{{ isEdit ? 'Edit' : 'Add' }} movie</h1>
      <router-link :to="{ name: 'home' }" class="link-gray">
        <v-icon>mdi-arrow-left</v-icon>
      </router-link>
      <v-btn class="save-button" variant="outlined" color="primary" @click="save">Save</v-btn>
    </div>
    <video
        :poster="form.image && (form.placeholderFile ? form.image : uploadsUrl + form.image)"
        ref="videoPlayer"
        class="video"
        controls
    >
      <source
          :src="form.video && (form.videoFile ? form.video : uploadsUrl + form.video)"
          type="video/mp4"
      >
    </video>
    <div class="movie-info mt-6 d-flex justify-space-between align-start">
      <div class="w-25">
        <v-file-input
            density="compact"
            label="Video file"
            variant="outlined"
            prepend-icon=""
            prepend-inner-icon="mdi-paperclip"
            class="file-input"
            :error-messages="getError('video')"
            :class="{ 'mb-3': getError('video') }"
            @update:model-value="setVideoFile"
        ></v-file-input>
        <v-file-input
            density="compact"
            label="Video placeholder"
            variant="outlined"
            prepend-icon=""
            prepend-inner-icon="mdi-camera"
            class="file-input"
            :error-messages="getError('image')"
            :class="{ 'mb-3': getError('image') }"
            @update:model-value="setPlaceholderFile"
        ></v-file-input>
        <v-text-field
            v-model="form.name"
            density="compact"
            variant="outlined"
            label="Name"
            :error-messages="getError('name')"
            :class="{ 'mb-3': getError('name') }"
        />
        <v-text-field
            v-model="form.release_date"
            density="compact"
            variant="outlined"
            label="Release date"
            type="date"
            class="date-picker"
            :error-messages="getError('release_date')"
            :class="{ 'mb-3': getError('release_date') }"
        />
        <v-select
            v-model="form.type"
            :items="types"
            item-title="name"
            item-value="id"
            density="compact"
            variant="outlined"
            label="Type"
            :error-messages="getError('type')"
            :class="{ 'mb-3': getError('type') }"
        />
        <v-select
            v-model="form.company"
            :items="companies"
            item-title="name"
            item-value="id"
            density="compact"
            variant="outlined"
            label="Company"
            :error-messages="getError('company')"
            :class="{ 'mb-3': getError('company') }"
        />
        <v-select
            v-model="form.directors"
            :items="directors"
            item-title="name"
            item-value="id"
            density="compact"
            variant="outlined"
            label="Directors"
            multiple
            :error-messages="getError('directors')"
            :class="{ 'mb-3': getError('directors') }"
        />
        <v-select
            v-model="form.countries"
            :items="countries"
            item-title="name"
            item-value="code"
            density="compact"
            variant="outlined"
            label="Countries"
            multiple
            :error-messages="getError('countries')"
            :class="{ 'mb-3': getError('countries') }"
        />
        <v-select
            v-model="form.genres"
            :items="genres"
            item-title="name"
            item-value="id"
            density="compact"
            variant="outlined"
            label="Genres"
            multiple
            :error-messages="getError('genres')"
            :class="{ 'mb-3': getError('genres') }"
        />
      </div>
      <v-textarea
          v-model="form.description"
          class="pl-6 w-75"
          label="Description"
          variant="outlined"
          auto-grow
          :error-messages="getError('description')"
          :class="{ 'mb-3': getError('description') }"
          rows="10"
      />
    </div>
  </div>
</template>

<script setup>
import {useRoute, useRouter} from 'vue-router'
import {computed, onMounted, ref} from "vue";
import Validation from "@/composables/Validation";
import axios from "axios";
import {toast} from "vue3-toastify";
import countries from '@/entities/countries'
import moment from "moment/moment";

const { errors, getError, handleErrors } = Validation()
const route = useRoute()
const router = useRouter()

const uploadsUrl = ref(import.meta.env.VITE_UPLOADS_URL)
const videoPlayer = ref(null)
const form = ref({
  name: '',
  description: '',
  release_date: '',
  video: '',
  image: '',
  videoFile: null,
  placeholderFile: null,
  type: null,
  company: null,
  directors: [],
  countries: [],
  genres: [],
})
const directors = ref([])
const companies = ref([])
const genres = ref([])
const types = ref([])

const isEdit = computed(() => parseInt(route.params.id) !== 0)

async function getList(apiRoute) {
  try {
    const response = await axios.get(apiRoute)
    return response.data
  } catch (error) {
    handleErrors(error)
    return []
  }
}

function setVideoFile(files) {
  let file = files.length ? files[0] : null
  form.value.videoFile = file
  form.value.video = file ? URL.createObjectURL(file) : null
  if (videoPlayer.value) {
    videoPlayer.value.load()
  }
}

function setPlaceholderFile(files) {
  let file = files.length ? files[0] : null
  form.value.placeholderFile = file
  form.value.image = file ? URL.createObjectURL(file) : null
}

async function save() {
  try {
    let data = new FormData()
    data.append('name', form.value.name)
    data.append('description', form.value.description || '')
    data.append('release_date', form.value.release_date)
    data.append('video', form.value.videoFile || '')
    data.append('image', form.value.placeholderFile || '')
    data.append('type', form.value.type || '')
    data.append('company', form.value.company || '')
    form.value.directors.forEach(item => data.append('directors[]', item))
    form.value.countries.forEach(item => data.append('countries[]', item))
    form.value.genres.forEach(item => data.append('genres[]', item))

    await axios[isEdit.value ? 'put' : 'post']('/movies/' + (isEdit.value ? route.params.id : ''), data)
    errors.value = []
    toast.success('Successfully saved')
    router.push({ name: 'home' })
  } catch (error) { handleErrors(error) }
}

async function getData() {
  try {
    const response = await axios.get(`/movies/${route.params.id}`)

    form.value = {
      ...response.data,
      release_date: moment(response.data.release_date).format('YYYY-MM-DD'),
      videoFile: null,
      placeholderFile: null,
      company: response.data.company.id,
      type: response.data.type.id,
      directors: response.data.directors.map(item => item.id),
      genres: response.data.genres.map(item => item.id),
    }

    if (videoPlayer.value) {
      videoPlayer.value.load()
    }
  } catch (error) { handleErrors(error) }
}

onMounted(async () => {
  if (isEdit.value) {
    await getData()
  }

  directors.value = await getList('/directors/')
  companies.value = await getList('/companies/')
  genres.value = await getList('/genres/')
  types.value = await getList('/types/')
})
</script>

<style lang="scss" scoped>
.movie {
  &-title {
    color: white;
    position: absolute;
    width: 100%;
    text-align: center;

    @media (max-width: 600px) {
      width: auto;
      left: 38px;
    }

    @media (max-width: 425px) {
      font-size: 28px !important;
    }
  }

  &-info {
    @media (max-width: 600px) {
      flex-direction: column;
    }

    & > .w-25 {
      @media (max-width: 767px) {
        width: 40% !important;
      }

      @media (max-width: 600px) {
        width: 100% !important;
      }
    }

    & > .w-75 {
      @media (max-width: 767px) {
        width: 60% !important;
      }

      @media (max-width: 600px) {
        width: 100% !important;
      }
    }
  }
}

.video {
  width: 100%;
  height: 700px;

  @media (max-width: 1024px) {
    height: calc(75vw - 48px);
  }

  &[poster] {
    width: 100%;
    height: 700px;
    object-fit: cover;

    @media (max-width: 1024px) {
      height: calc(75vw - 48px);
    }
  }
}

.save-button {
  height: 42px;
  width: 150px;

  @media (max-width: 600px) {
    width: 120px;
  }

  @media (max-width: 374px) {
    width: 70px;
  }
}

:deep(.file-input) {
  .v-field__input {
    display: flex;
    align-items: center;
  }
}

:deep(.date-picker) {
  input {
    padding-top: 10px;
    padding-bottom: 10px;
    display: block;
  }
}

.v-textarea {
  @media (max-width: 600px) {
    padding-left: 0 !important;
  }
}
</style>