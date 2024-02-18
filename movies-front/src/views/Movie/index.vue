<template>
  <div v-if="movie" class="movie">
    <div class="d-flex align-center justify-space-between position-relative mb-6">
      <h1 class="text-h4 movie-title">{{ movie.name }}</h1>
      <router-link :to="{ name: 'home' }" class="link-gray">
        <v-icon>mdi-arrow-left</v-icon>
      </router-link>
      <div class="mx-0 d-flex align-center rating position-relative" :class="{ 'selected': movie.userRating }">
        <v-rating
          :model-value="movie.userRating || movie.rating"
          color="amber"
          density="compact"
          half-increments
          size="medium"
          @update:modelValue="rate"
        ></v-rating>
        <div v-if="movie.rating" class="text-grey ms-2 mt-1">{{ movie.rating }} ({{ movie.ratingsCount }})</div>
      </div>
    </div>
    <video
        :poster="movie.image && (uploadsUrl + movie.image)"
        ref="videoPlayer"
        class="video"
        controls
        @loadedmetadata="setDuration"
    >
      <source :src="uploadsUrl + movie.video" type="video/mp4">
    </video>
    <div class="movie-info-wrapper mt-6 d-flex justify-space-between">
      <div class="movie-info">
        <div class="text-grey"><b>Release date:</b> {{ movie.release_date }}</div>
        <div class="text-grey"><b>Type:</b> {{ movie.type.name }}</div>
        <div class="text-grey"><b>Company:</b> {{ movie.company.name }}</div>
        <div class="text-grey"><b>Directors: </b>
          <span v-for="(item, index) in movie.directors" :key="item.id">
            <router-link :to="{ name: 'director-preview', params: { id: item.id } }">
              {{ item.name }}
            </router-link>{{ index !== movie.directors.length - 1 ? ', ' : '' }}
          </span>
        </div>
        <div class="text-grey"><b>Countries:</b> {{ movie.countries.map(item => item.name).join(', ') }}</div>
        <div class="text-grey"><b>Genres:</b> {{ movie.genres.map(item => item.name).join(', ') }}</div>
        <div class="text-grey"><b>Movie duration:</b> {{ duration }}</div>
      </div>
      <div class="text-grey w-100"><b>Description:</b> {{ movie.description }}</div>
    </div>
    <h2 v-if="movies.length" class="text-h5 mt-8">Similar Movies</h2>
    <Movies :movies="movies" />
    <h2 class="text-h5 mt-5 mb-4">Comments</h2>
    <div class="comments">
      <div class="comment-wrapper">
        <v-textarea
            v-model="comment"
            label="Add a comment"
            variant="outlined"
            auto-grow
            :error-messages="getError('comment')"
        />
        <div class="comment-actions">
          <v-icon class="icon-button" @click="clearComment">mdi-close</v-icon>
          <v-icon class="ml-2 icon-button" @click="send">mdi-send</v-icon>
        </div>
      </div>
      <div class="comments-list">
        <div v-for="(item, index) in comments">
          <v-divider class="my-2" v-if="index !== 0"></v-divider>
          <div class="item-comments-heading">
            <div class="d-flex align-center">
              <div class="comment-logo-wrapper">
                <img
                    v-if="item.user.image" :src="uploadsUrl + item.user.image"
                    class="comment-logo"
                    :alt="item.user.image"
                >
                <v-icon v-else size="35" dark>mdi-account</v-icon>
              </div>
              <div class="d-flex flex-column">
                <v-card-title class="w-100 py-0">{{ item.user.name }}</v-card-title>
                <v-card-subtitle>{{ moment(item.created_at).format('DD-MM-YYYY HH:mm') }}</v-card-subtitle>
              </div>
              <div v-if="user && item.user.id === user.id" class="d-flex align-center ml-auto">
                <v-icon class="mr-2 icon-button" dark @click="editComment(item)">mdi-pencil</v-icon>
                <v-icon class="icon-button" dark @click="removeComment(item.id)">mdi-delete</v-icon>
              </div>
            </div>
          </div>
          <div class="w-100 px-0 pt-0">{{ item.comment }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRoute } from 'vue-router'
import {onMounted, ref, watch} from "vue";
import moment from 'moment';
import Movies from '@/components/Movies.vue'
import axios from "axios";
import countries from '@/entities/countries'
import Validation from "@/composables/Validation";
import {toast} from "vue3-toastify";
import CurrentUser from "@/composables/CurrentUser";

const { user } = CurrentUser()
const { errors, getError, handleErrors } = Validation()
const route = useRoute()

const uploadsUrl = ref(import.meta.env.VITE_UPLOADS_URL)
const movie = ref(null)
const movies = ref([])
const comment = ref('')
const commentId = ref(null)
const comments = ref([])
const videoPlayer = ref(null)
const duration = ref(0)

function setDuration() {
  if (videoPlayer.value) {
    const totalSeconds = parseInt(videoPlayer.value.duration);
    const totalMinutes = Math.floor(totalSeconds / 60);

    const seconds = totalSeconds % 60;
    const hours = Math.floor(totalMinutes / 60);
    const minutes = totalMinutes % 60;

    duration.value = `
      ${hours ? hours + 'h' : ''}
      ${minutes ? minutes + 'm' : ''}
      ${seconds ? seconds + 's' : ''}
    `;
  }
}

async function getMovies() {
  try {
    const response = await axios.get('/movies/', {
      params: {
        genres: movie.value.genres.map(item => item.id),
        currentMovie: movie.value.id
      }
    })
    movies.value = response.data.data
  } catch (error) { handleErrors(error) }
}

async function getComments() {
  try {
    const response = await axios.get('/comments/', {
      params: { movie: movie.value.id }
    })
    comments.value = response.data
  } catch (error) { handleErrors(error) }
}

async function removeComment(id) {
  try {
    await axios.delete(`/comments/${id}`)
    toast.success('Successfully removed')
    await getComments()
    if (commentId.value === id) {
      commentId.value = null
      comment.value = ''
    }
  } catch (error) { handleErrors(error) }
}

async function editComment(item) {
  comment.value = item.comment
  commentId.value = item.id
}

async function getData() {
  try {
    const response = await axios.get(`/movies/${route.params.id}`)

    movie.value = {
      ...response.data,
      release_date: moment(response.data.release_date).format('DD-MM-YYYY'),
      countries: response.data.countries.map(item => countries.find(country => country.code === item))
    }

    if (videoPlayer.value) {
      videoPlayer.value.load()
    }
  } catch (error) { handleErrors(error) }
}

async function rate(rating) {
  try {
    let response = null;
    if (movie.value.userRating) {
      response = await axios.put(`/ratings/${movie.value.id}`, { rating })
    } else {
      response = await axios.post('/ratings/', { rating, movie: movie.value.id })
    }
    movie.value.userRating = response.data.userRating
    movie.value.rating = response.data.rating
    movie.value.ratingsCount = response.data.ratingsCount
  } catch (error) { handleErrors(error) }
}

function clearComment() {
  comment.value = ''
  commentId.value = null
}

async function send() {
  try {
    await axios[commentId.value ? 'put' : 'post']('/comments/' + (commentId.value ? commentId.value : ''), {
      comment: comment.value,
      movie: movie.value.id
    })
    errors.value = []
    comment.value = ''
    toast.success('Comment sent')
    await getComments()
  } catch (error) { handleErrors(error) }
}

onMounted(async () => {
  await getData()
  await getMovies()
  await getComments()
})

watch(() => route, async () => {
  if (route.name === 'movie') {
    await getData()
    await getMovies()
    await getComments()
  }
}, { deep: true })
</script>

<style lang="scss" scoped>
.movie {
  @media (max-width: 600px) {
    padding-top: 38px;
  }

  &-title {
    color: white;
    position: absolute;
    width: 100%;
    text-align: center;

    @media (max-width: 600px) {
      bottom: calc(100% + 8px);
    }
  }

  &-info {
    min-width: 350px;
    max-width: 350px;

    @media (max-width: 800px) {
      min-width: 280px;
      max-width: 280px;
    }

    @media (max-width: 600px) {
      min-width: unset;
      max-width: unset;
      width: 100%;
    }

    &-wrapper {
      @media (max-width: 600px) {
        flex-direction: column;
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

.rating {
  &.selected {
    :deep(.v-rating) {
      .v-btn__content {
        color: #BB86FC !important;
      }
    }
  }
}

.comments {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;

  @media (max-width: 600px) {
    width: 100%;
    flex-direction: column;
  }

  .comment {
    &-wrapper {
      width: 50%;
      position: relative;

      @media (max-width: 600px) {
        width: 100%;
      }
    }

    &-actions {
      position: absolute;
      bottom: 30px;
      right: 10px;
    }
  }

  .v-input {
    width: 100%;
  }

  &-list {
    width: 50%;
    margin-left: 24px;

    @media (max-width: 600px) {
      width: 100%;
      margin-left: 0;
      margin-top: 24px;
    }

    .comment-logo {
      width: 100%;
      height: 100%;
      object-fit: cover;

      &-wrapper {
        width: 35px;
        height: 35px;
        border-radius: 100%;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
      }
    }
  }
}
</style>