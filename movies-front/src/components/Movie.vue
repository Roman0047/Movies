<template>
  <div class="movie pb-3">
    <router-link :to="{ name: 'movie', params: { id: movie.id } }">
      <v-card class="mx-auto" max-width="374">
        <v-row v-if="movie.rating" align="center" class="mx-0 rating">
          <v-rating
            :model-value="movie.rating"
            color="amber"
            density="compact"
            half-increments
            readonly
            size="small"
          ></v-rating>
          <div class="text-grey ms-2 mt-1">{{ movie.rating }} ({{ movie.ratingsCount }})</div>
        </v-row>
        <div class="movie-image-wrapper">
          <v-img v-if="movie.image" class="movie-image" :src="uploadsUrl + movie.image" cover />
          <v-icon v-else size="80" dark>mdi-movie-open</v-icon>
        </div>

        <v-card-item class="pb-1">
          <div class="d-flex align-center justify-space-between" :class="{ 'is-admin-actions': isAdmin }">
            <v-card-title>{{ movie.name }}</v-card-title>
            <div v-if="isAdmin" class="d-flex align-center">
              <router-link :to="{ name: 'movie-edit', params: { id: movie.id } }" class="link-gray mr-2">
                <v-icon dark>mdi-pencil</v-icon>
              </router-link>
              <v-icon class="icon-button delete-movie" dark @click.prevent="remove">mdi-delete</v-icon>
            </div>
          </div>
          <div class="d-flex align-center justify-space-between">
            <v-card-subtitle class="countries">{{ countriesList.join(', ') }}</v-card-subtitle>
            <v-card-subtitle>{{ moment(movie.release_date).format('YYYY') }}</v-card-subtitle>
          </div>
        </v-card-item>
        <v-card-text>
          <div>{{ movie.genres.map(item => item.name).join(', ') }}</div>
        </v-card-text>
      </v-card>
    </router-link>
  </div>
</template>

<script setup>
import countries from '@/entities/countries'
import {computed, ref} from "vue";
import axios from "axios";
import {toast} from "vue3-toastify";
import Validation from "@/composables/Validation";
import moment from "moment/moment";
import CurrentUser from "@/composables/CurrentUser";

const { handleErrors } = Validation()
const { isAdmin } = CurrentUser()

const props = defineProps({
  movie: {
    type: Object,
    default: () => {
      return {}
    }
  }
})

const emit = defineEmits(['update:list'])

const uploadsUrl = ref(import.meta.env.VITE_UPLOADS_URL)

const countriesList = computed(() => {
  return props.movie.countries.map(item => {
    const country = countries.find(country => country.code === item)
    return country?.name
  })
})

async function remove() {
  try {
    await axios.delete(`/movies/${props.movie.id}`)
    toast.success('Successfully removed')
    emit('update:list')
  } catch (error) { handleErrors(error) }
}
</script>

<style lang="scss" scoped>
.rating {
  position: absolute;
  top: 6px;
  right: 0;
  padding: 2px 4px;
  border-bottom-left-radius: 5px;
  background-color: #212121;
  z-index: 2;
}

.movie {
  width: 15.9%;
  margin-right: 0.76%;

  @media (max-width: 1120px) {
    width: 31.8%;
    margin-right: 1.52%;
  }

  @media (max-width: 600px) {
    width: 47%;
    margin-right: 3%;
  }

  @media (max-width: 430px) {
    width: calc(100%);
    margin-right: 0;
  }

  & > a {
    height: 100%;
    display: block;

    .v-card {
      height: 100%;
    }
  }

  &-image {
    border-top-right-radius: 6px;
    height: 100%;

    &-wrapper {
      height: 230px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
  }

  .countries {
    width: calc(100% - 50px);
  }

  .delete-movie {
    margin-right: -4px;
  }

  .is-admin-actions {
    .v-card-title {
      width: calc(100% - 54px);
    }
  }
}
</style>