<template>
  <div>
    <div class="header mb-6">
      <h1 class="text-h4">Directors</h1>
      <div class="d-flex align-center">
        <div class="btn-wrapper ml-2">
          <v-btn :to="{ name: 'director', params: { id: 0 } }" variant="outlined" color="primary">
            Add
          </v-btn>
        </div>
      </div>
    </div>
    <v-table v-if="items.length">
      <thead>
      <tr>
        <th class="text-left">Image</th>
        <th class="text-left">Name</th>
        <th class="text-left">Rewards</th>
        <th class="text-left">Bio</th>
        <th class="text-left"></th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="(item, index) in items" :key="index">
        <td class="py-2">
          <div class="logo-wrapper w-100 d-flex justify-center">
            <img
              v-if="item.image"
              :src="uploadsUrl + item.image"
              :alt="item.image"
            />
            <v-icon v-else class="icon-button" size="x-large" dark>mdi-account</v-icon>
          </div>
        </td>
        <td class="text-no-wrap">{{ item.name }}</td>
        <td class="py-2 w-25">{{ item.rewards }}</td>
        <td class="py-2 w-100 bio">{{ item.bio }}</td>
        <td>
          <div class="d-flex align-center">
            <router-link :to="{ name: 'director', params: { id: item.id } }">
              <v-icon class="mr-2 icon-button" dark>mdi-pencil</v-icon>
            </router-link>
            <v-icon class="icon-button" dark @click="remove(item.id)">mdi-delete</v-icon>
          </div>
        </td>
      </tr>
      </tbody>
    </v-table>

    <v-pagination
        v-if="pagination.last_page !== 1"
        v-model="pagination.current_page"
        :length="pagination.last_page"
        @update:model-value="getList"
    ></v-pagination>
  </div>
</template>

<script setup>
import {onMounted, ref} from 'vue'
import axios from "axios";
import Validation from "@/composables/Validation";
import {toast} from "vue3-toastify";

const { handleErrors } = Validation()

const uploadsUrl = ref(import.meta.env.VITE_UPLOADS_URL)
const items = ref([])
const pagination = ref({
  current_page: 1,
  first_page: 1,
  last_page: 1,
  per_page: 10,
  total: 1
})

onMounted(() => {
  getList()
})

async function getList() {
  try {
    const response = await axios.get('/directors/', {
      params: {
        page: pagination.value.current_page,
        limit: pagination.value.per_page
      }
    })
    items.value = response.data.data
    pagination.value = response.data.meta
  } catch (error) { handleErrors(error) }
}

async function remove(id) {
  try {
    await axios.delete(`/directors/${id}`)
    toast.success('Successfully removed')
    await getList()
  } catch (error) { handleErrors(error) }
}
</script>

<style lang="scss" scoped>
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;

  :deep(.v-text-field) {
    width: 300px;
    max-width: 300px;

    input {
      height: 42px;
      min-height: unset;
      padding-top: 14px;
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

.edit-field {
  outline: none;
  border: none;
}

.bio {
  min-width: 500px;
}

.logo-wrapper {
  img {
    width: 70px;
    height: 45px;
    object-fit: cover;
  }
}
</style>