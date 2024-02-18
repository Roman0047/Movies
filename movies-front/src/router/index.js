import { createRouter, createWebHistory } from 'vue-router'
import DefaultLayout from '../layouts/Default.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      meta: { layout: DefaultLayout },
      component: () => import('../views/Home.vue')
    },
    {
      path: '/sign-in',
      name: 'sign-in',
      meta: { auth: false },
      component: () => import('../views/SignIn.vue')
    },
    {
      path: '/sign-up',
      name: 'sign-up',
      meta: { auth: false },
      component: () => import('../views/SignUp.vue')
    },
    {
      path: '/movie/:id',
      name: 'movie',
      meta: { layout: DefaultLayout },
      component: () => import('../views/Movie/index.vue')
    },
    {
      path: '/movie/edit/:id',
      name: 'movie-edit',
      meta: { layout: DefaultLayout, auth: { roles: 'admin', redirect: '/sign-in' } },
      component: () => import('../views/Movie/Form.vue')
    },
    {
      path: '/types',
      name: 'types',
      meta: { layout: DefaultLayout, auth: { roles: 'admin', redirect: '/sign-in' } },
      component: () => import('../views/Types.vue')
    },
    {
      path: '/genres',
      name: 'genres',
      meta: { layout: DefaultLayout, auth: { roles: 'admin', redirect: '/sign-in' } },
      component: () => import('../views/Genres.vue')
    },
    {
      path: '/directors',
      name: 'directors',
      meta: { layout: DefaultLayout, auth: { roles: 'admin', redirect: '/sign-in' } },
      component: () => import('../views/Directors/index.vue')
    },
    {
      path: '/companies',
      name: 'companies',
      meta: { layout: DefaultLayout, auth: { roles: 'admin', redirect: '/sign-in' } },
      component: () => import('../views/Companies.vue')
    },
    {
      path: '/directors/:id',
      name: 'director',
      meta: { layout: DefaultLayout, auth: { roles: 'admin', redirect: '/sign-in' } },
      component: () => import('../views/Directors/Form.vue')
    },
    {
      path: '/director/:id',
      name: 'director-preview',
      meta: { layout: DefaultLayout, auth: { roles: ['user', 'admin'], redirect: '/sign-in' } },
      component: () => import('../views/Directors/Preview.vue')
    },
    {
      path: '/profile',
      name: 'profile',
      meta: { layout: DefaultLayout, auth: { roles: ['user', 'admin'], redirect: '/sign-in' } },
      component: () => import('../views/Profile.vue')
    }
  ]
})

export default router
