<template>
  <div>
    <div class="header mb-6">
      <h1 class="text-h4">{{ title }}</h1>
      <div class="create-form d-flex align-center">
        <v-text-field
            variant="outlined"
            v-model="newItem.name"
            label="Name"
            :error-messages="getError('name')"
        />
        <div class="btn-wrapper ml-2">
          <v-btn variant="outlined" color="primary" @click="save">{{ isEdit ? 'Edit' : 'Add' }}</v-btn>
        </div>
      </div>
    </div>
    <v-table v-if="items.length">
      <thead>
      <tr>
        <th class="text-left">Name</th>
        <th class="text-left"></th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="(item, index) in items" :key="index">
        <td class="w-100">
          <input class="edit-field w-100" type="text" readonly :value="item.name">
        </td>
        <td>
          <div class="d-flex align-center">
            <v-icon class="mr-2 icon-button" dark @click="setEditItem(item)">mdi-pencil</v-icon>
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
import {toast} from "vue3-toastify";
import Validation from "@/composables/Validation";

const { errors, getError, handleErrors } = Validation()

const props = defineProps({
  title: {
    type: String,
    default: () => []
  },
  apiRoute: {
    type: String,
    default: () => []
  }
})

const newItem = ref({
  name: ''
})
const isEdit = ref(false)
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
    const response = await axios.get(props.apiRoute, {
      params: {
        page: pagination.value.current_page,
        limit: pagination.value.per_page
      }
    })
    items.value = response.data.data
    pagination.value = response.data.meta
  } catch (error) { handleErrors(error) }
}

async function save() {
  try {
    await axios[isEdit.value ? 'put' : 'post'](props.apiRoute + (newItem.value.id || ''), newItem.value)
    toast.success(`Successfully ${isEdit.value ? 'updated' : 'created'}`)
    isEdit.value = false
    await getList()
    errors.value = []
    newItem.value = {
      name: ''
    }
  } catch (error) { handleErrors(error) }
}

async function remove(id) {
  try {
    await axios.delete(props.apiRoute + id)
    toast.success('Successfully removed')
    await getList()
  } catch (error) { handleErrors(error) }
}

async function setEditItem(item) {
  newItem.value = item
  isEdit.value = true
  errors.value = []
}
</script>

<style lang="scss" scoped>
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;

  @media (max-width: 600px) {
    flex-direction: column;

    .text-h4 {
      margin-bottom: 24px;
    }
  }

  .create-form {
    @media (max-width: 600px) {
      width: 100%;
    }
  }

  :deep(.v-text-field) {
    width: 300px;
    max-width: 300px;
    height: 42px;

    @media (max-width: 600px) {
      width: 100%;
      max-width: unset;
    }

    input {
      height: 42px;
      min-height: unset;
      padding-top: 14px;
    }

    .v-input__details {
      min-height: 18px;
      padding: 0;
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
</style>