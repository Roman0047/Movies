import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import 'vuetify/styles'
import '@mdi/font/css/materialdesignicons.css'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import axios from 'axios'
import auth from "./plugins/auth";
import Vue3Toastify from 'vue3-toastify';
import 'vue3-toastify/dist/index.css';

const app = createApp(App)

const vuetify = createVuetify({
  components,
  directives,
  theme: {
    defaultTheme: 'dark'
  }
})

app.use(vuetify)
app.use(router)
app.use(auth)
app.use(Vue3Toastify, {
  autoClose: 3000,
  theme: 'dark',
  position: 'bottom-left'
})

axios.defaults.baseURL = import.meta.env.VITE_API_URL

app.mount('#app')
