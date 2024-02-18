<template>
  <header>
    <div class="inner">
      <div class="d-flex align-center">
        <router-link :to="{ name: 'home' }">
          <v-card-title class="pa-0">Movies</v-card-title>
        </router-link>
        <router-link v-if="isAdmin" :to="{ name: 'movie-edit', params: { id: 0 } }" class="link-gray ml-1">
          <v-icon class="icon-button" large dark>mdi-plus</v-icon>
        </router-link>
      </div>
      <div class="d-flex align-center justify-center">
        <v-text-field
            v-model="search"
            ref="searchRef"
            class="search"
            placeholder="Search for movies"
            variant="outlined"
            hide-details
            clearable
            @change="searchMovies"
            @click:clear="searchMovies"
        >
          <template v-slot:append-inner>
            <v-icon class="icon-button" @click="searchMovies">mdi-magnify</v-icon>
          </template>
        </v-text-field>
        <div v-if="!user">
          <div class="auth-actions">
            <v-btn :to="{ name: 'sign-in' }" variant="plain" color="white">Sign In</v-btn>
            <v-btn :to="{ name: 'sign-up' }" variant="plain" color="white">Sign Up</v-btn>
          </div>
          <div class="auth-actions-mobile">
            <router-link :to="{ name: 'sign-in' }" class="link-gray">
              <v-icon class="icon-button" large dark>mdi-account</v-icon>
            </router-link>
          </div>
        </div>
        <template v-else>
          <router-link :to="{ name: 'profile' }" class="link-gray">
            <v-icon class="icon-button" large dark>mdi-account</v-icon>
          </router-link>
          <v-icon v-if="user" class="icon-button ml-3" large dark @click="logout">mdi-logout</v-icon>

          <v-menu v-if="isAdmin">
            <template v-slot:activator="{ props }">
              <v-icon v-bind="props" class="icon-button ml-3" large dark>mdi-menu</v-icon>
            </template>
            <v-list>
              <v-list-item v-for="(item, index) in adminItems" :key="index" :to="{ name: item.page }">
                <v-list-item-title>{{ item.title }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </template>
      </div>
    </div>
  </header>
</template>

<script setup>
import {ref, nextTick, onMounted} from "vue";
import {useAuth} from "@websanova/vue-auth";
import CurrentUser from "../composables/CurrentUser";
import {useRoute, useRouter} from "vue-router";

const { isAdmin, user } = CurrentUser()

const $auth = useAuth()
const router = useRouter()
const route = useRoute()

const search = ref('')
const searchRef = ref(null)
const adminItems = ref([
  {
    title: 'Types',
    page: 'types',
  },
  {
    title: 'Genres',
    page: 'genres',
  },
  {
    title: 'Companies',
    page: 'companies',
  },
  {
    title: 'Directors',
    page: 'directors',
  },
])

function logout() {
  $auth.logout({
    makeRequest: true,
    redirect: { name: 'sign-in' }
  });
}

async function searchMovies() {
  await router.push({
    name: 'home',
    query: search.value ? { search: search.value } : null
  })

  if (searchRef.value) {
    await nextTick()
    searchRef.value.blur()
  }
}

onMounted(() => {
  if (route.query.search) {
    search.value = route.query.search
  }
})
</script>

<style lang="scss" scoped>
header {
  height: 48px;
  display: flex;
  justify-content: center;
  position: relative;

  @media (max-width: 430px) {
    height: 88px;
    padding-bottom: 40px;
  }

  &:before {
    content: "";
    position: absolute;
    height: 100%;
    width: 100vw;
    background-color: #212121;
    z-index: -1;
  }

  .inner {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;

    .v-card-title {
      color: rgba(235, 235, 235, 0.64);
      transition: color 0.2s ease;

      &:hover {
        color: #ffffff;
      }
    }

    .auth-actions {
      @media (max-width: 600px) {
        display: none;
      }

      &-mobile {
        display: none;

        @media (max-width: 600px) {
          display: block;
        }
      }
    }

    .search {
      width: 200px;
      margin-right: 20px;

      @media (max-width: 600px) {
        width: 180px;
        margin-right: 10px;
      }

      @media (max-width: 430px) {
        width: 100%;
        position: absolute;
        left: 0;
        bottom: 4px;
      }

      :deep(.v-field__field) {
        height: 40px;

        input {
          height: 40px;
          min-height: unset;
          padding-top: 14px;

          &::placeholder {
            opacity: .8;
          }
        }
      }
    }
  }
}
</style>