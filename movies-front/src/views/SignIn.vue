<template>
  <div class="d-flex align-center justify-center h-100">
    <v-card width="400" class="mx-auto">
      <v-card-title>Sign In</v-card-title>
      <v-card-text>
        <v-form class="d-flex flex-column" @submit.prevent="login">
          <v-text-field
              variant="underlined"
              v-model="form.email"
              label="Email"
              :error-messages="getError('email')"
              :hide-details="!getError('email')"
              class="mb-4"
          />
          <v-text-field
              variant="underlined"
              v-model="form.password"
              label="Password"
              :error-messages="getError('password')"
              :hide-details="!getError('password')"
              class="mb-4"
              type="password"
          />
          <v-btn type="submit" variant="outlined" color="primary" class="mt-2">Sign In</v-btn>
        </v-form>
        <div class="mt-4">
          <p class="text-center">
            Don't have an account?
            <router-link :to="{ name: 'sign-up' }">Sign Up</router-link>
          </p>
        </div>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import {useAuth} from "@websanova/vue-auth";
import Validation from "@/composables/Validation";

const { errors, getError, handleErrors } = Validation()

const $auth = useAuth()

const form = ref({
  email: '',
  password: '',
})

async function login() {
  try {
    await $auth.login({
      data: form.value,
      staySignedIn: true,
      fetchUser: true,
      redirect: { name: 'home' }
    });
  } catch (error) { handleErrors(error) }
}
</script>

<style lang="scss" scoped>
.v-card {
  @media (max-width: 448px) {
    max-width: calc(100vw - 48px);
  }
}
</style>