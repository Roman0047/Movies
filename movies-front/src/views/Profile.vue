<template>
  <div>
    <div class="header mb-6">
      <div class="d-flex align-center">
        <h1 class="text-h4">Profile</h1>
      </div>
      <div class="d-flex align-center">
        <div class="btn-wrapper ml-2">
          <v-btn variant="outlined" color="primary" @click="save">Save</v-btn>
        </div>
      </div>
    </div>
    <div class="form-content d-flex align-start">
      <div class="upload-wrapper">
        <div class="upload icon-button" :class="{ 'invalid': getError('image') }" @click="selectFile">
          <img
              v-if="form.image"
              :src="form.logoFile ? form.image : uploadsUrl + form.image"
              :alt="form.image"
          >
          <v-icon v-else size="100" dark>mdi-account</v-icon>
        </div>
        <div v-if="getError('image')" class="validation-error">{{ getError('image') }}</div>
      </div>
      <input type="file" ref="file" accept="image/*" @change="saveFile" hidden>
      <div class="form">
        <v-card-title class="pl-0 pt-0">General info</v-card-title>
        <v-text-field
            v-model="form.name"
            variant="outlined"
            label="Name"
            :error-messages="getError('name')"
            :class="{ 'mb-3': getError('name') }"
        />
        <v-text-field
            v-model="form.email"
            variant="outlined"
            label="Email"
            :error-messages="getError('email')"
            :class="{ 'mb-3': getError('email') }"
        />
        <v-card-title class="pl-0">Change password</v-card-title>
        <v-text-field
            v-model="form.currentPassword"
            variant="outlined"
            label="Current password"
            :error-messages="getError('currentPassword')"
            :class="{ 'mb-3': getError('currentPassword') }"
        />
        <v-text-field
            v-model="form.password"
            variant="outlined"
            label="New password"
            :error-messages="getError('password')"
            :class="{ 'mb-3': getError('password') }"
        />
        <v-text-field
            v-model="form.repeatPassword"
            variant="outlined"
            label="Repeat new password"
            :error-messages="getError('repeatPassword')"
            :class="{ 'mb-3': getError('repeatPassword') }"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import Validation from "@/composables/Validation";
import {useAuth} from "@websanova/vue-auth";
import axios from "axios";
import {toast} from "vue3-toastify";
import {onMounted, ref} from "vue";

const { errors, getError, handleErrors } = Validation()

const $auth = useAuth()

const file = ref(null)
const uploadsUrl = ref(import.meta.env.VITE_UPLOADS_URL)
const form = ref({
  name: '',
  email: '',
  image: '',
  logoFile: null,
  currentPassword: '',
  password: '',
  repeatPassword: ''
})

async function save() {
  try {
    let data = new FormData()
    data.append('name', form.value.name)
    data.append('email', form.value.email)
    data.append('currentPassword', form.value.currentPassword)
    data.append('password', form.value.password)
    data.append('repeatPassword', form.value.repeatPassword)
    data.append('image', form.value.logoFile || '')

    const response = await axios.post('/profile/', data)
    errors.value = []
    $auth.user(response.data)
    updateUser()
    toast.success('Successfully saved')
  } catch (error) { handleErrors(error) }
}

function selectFile() {
  if (file.value) {
    file.value.click()
  }
}

function saveFile() {
  let file = event.target.files.length ? event.target.files[0] : null

  if (file) {
    form.value.logoFile = file
    form.value.image = URL.createObjectURL(file)
  }
}

function updateUser() {
  const user = $auth.user()
  if (user) {
    form.value = {
      name: user.name,
      email: user.email,
      image: user.image,
      logoFile: null,
      currentPassword: '',
      password: '',
      repeatPassword: '',
    }
  }
}

onMounted(() => {
  updateUser()
})
</script>

<style lang="scss" scoped>
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;

  .text-h4 {
    @media (max-width: 425px) {
      font-size: 28px !important;
    }
  }

  .v-btn {
    height: 42px;
    width: 150px;

    @media (max-width: 600px) {
      width: 120px;
    }
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
  border: 2px dashed #A2A2A2;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  overflow: hidden;

  @media (max-width: 1024px) {
    width: 300px;
    height: 225px;
  }

  @media (max-width: 767px) {
    width: 100%;
    height: calc(75vw - 48px);
  }

  &-wrapper {
    @media (max-width: 767px) {
      width: 100%;
    }
  }

  &.invalid {
    border: 2px dashed #CF6679FF;
  }

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  img, .v-icon {
    transition: transform .5s ease;
  }

  &:hover {
    img, .v-icon {
      transform: scale(1.1);
    }
  }
}

.form {
  margin-left: 24px;
  flex: 1;

  @media (max-width: 767px) {
    width: 100%;
    margin-left: 0;
    margin-top: 38px;
  }
}

.validation-error {
  font-size: 12px;
  margin-top: 4px;
  color: #CF6679FF;
}
</style>