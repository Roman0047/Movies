<template>
  <div>
    <div class="header mb-6">
      <div class="d-flex align-center">
        <router-link :to="{ name: 'directors' }" class="link-gray mr-4">
          <v-icon>mdi-arrow-left</v-icon>
        </router-link>
        <h1 class="text-h4">{{ isEdit ? 'Edit' : 'Add' }} director</h1>
      </div>
      <div class="d-flex align-center">
        <div class="btn-wrapper ml-2">
          <v-btn variant="outlined" color="primary" @click="save">Save</v-btn>
        </div>
      </div>
    </div>
    <div class="form-content d-flex align-start">
      <div>
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
        <v-text-field
            v-model="form.name"
            variant="outlined"
            label="Name"
            :error-messages="getError('name')"
            :class="{ 'mb-3': getError('name') }"
        />
        <v-text-field
            v-model="form.rewards"
            variant="outlined"
            label="Rewards"
            :error-messages="getError('rewards')"
            :class="{ 'mb-3': getError('rewards') }"
        />
        <v-textarea
            v-model="form.bio"
            variant="outlined"
            label="Biography"
            :error-messages="getError('bio')"
            :class="{ 'mb-3': getError('bio') }"
            auto-grow
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import {computed, onMounted, ref} from "vue";
import axios from "axios";
import {toast} from "vue3-toastify";
import Validation from "@/composables/Validation";
import {useRoute, useRouter} from "vue-router";

const { errors, getError, handleErrors } = Validation()
const router = useRouter()
const route = useRoute()

const file = ref(null)
const uploadsUrl = ref(import.meta.env.VITE_UPLOADS_URL)

const form = ref({
  name: '',
  rewards: '',
  bio: '',
  logoFile: null,
})

const isEdit = computed(() => parseInt(route.params.id) !== 0)

async function save() {
  try {
    let data = new FormData()
    data.append('name', form.value.name)
    data.append('rewards', form.value.rewards)
    data.append('bio', form.value.bio || '')
    data.append('image', form.value.logoFile || '')

    await axios[isEdit.value ? 'put' : 'post']('/directors/' + (isEdit.value ? route.params.id : ''), data)
    errors.value = []
    toast.success('Successfully saved')
    router.push({ name: 'directors' })
  } catch (error) { handleErrors(error) }
}

function selectFile() {
  if (file.value) {
    file.value.click()
  }
}

function saveFile(event) {
  let file = event && event.target.files.length ? event.target.files[0] : null

  if (file) {
    form.value.logoFile = file
    form.value.image = URL.createObjectURL(file)
  }
}

async function getData() {
  try {
    const response = await axios.get(`/directors/${route.params.id}`)

    form.value = {
      ...response.data,
      logoFile: null,
    }
  } catch (error) { handleErrors(error) }
}

onMounted(() => {
  if (isEdit.value) {
    getData()
  }
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

    @media (max-width: 374px) {
      width: 70px;
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
    margin-top: 24px;
  }
}

.validation-error {
  font-size: 12px;
  margin-top: 4px;
  color: #CF6679FF;
}
</style>