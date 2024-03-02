import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import vuetify from "./plugins/vuetify";
import axios from 'axios'
import auth from "./plugins/auth";
import Vue3Toastify from 'vue3-toastify';
import 'vue3-toastify/dist/index.css';

const app = createApp(App)

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
