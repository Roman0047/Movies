<template>
  <div class="d-flex align-center justify-center h-100">
    <v-card width="400" class="mx-auto">
      <v-card-title>Sign Up</v-card-title>
      <v-card-text>
        <v-form class="d-flex flex-column" @submit.prevent="register">
          <v-text-field
              variant="underlined"
              v-model="form.name"
              label="Name"
              :error-messages="getError('name')"
              :hide-details="!getError('name')"
              class="mb-4"
          />
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
          <v-text-field
              variant="underlined"
              v-model="form.repeatPassword"
              label="Repeat Password"
              :error-messages="getError('repeatPassword')"
              :hide-details="!getError('repeatPassword')"
              class="mb-4"
              type="password"
          />
          <v-btn type="submit" variant="outlined" color="primary" class="mt-2">Sign Up</v-btn>
        </v-form>
        <div class="mt-4">
          <p class="text-center">
            Already have an account?
            <router-link :to="{ name: 'sign-in' }">Sign In</router-link>
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
  name: '',
  email: '',
  password: '',
  repeatPassword: '',
})

async function register() {
  try {
    await $auth.register({
      data: form.value,
      autoLogin: true,
      staySignedIn: true,
      fetchUser: true,
      redirect: { name: 'home' }
    });
    errors.value = []
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