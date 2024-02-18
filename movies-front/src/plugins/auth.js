import {createAuth} from "@websanova/vue-auth";
import axios from "axios";
import router from "../router";
import driverAuthBearer from '@websanova/vue-auth/dist/drivers/auth/bearer.esm.js';
import driverHttpAxios from '@websanova/vue-auth/dist/drivers/http/axios.1.x.esm.js';
import driverRouterVueRouter from '@websanova/vue-auth/dist/drivers/router/vue-router.2.x.esm.js';

export default createAuth({
  plugins: {
    http: axios,
    router: router
  },
  drivers: {
    http: driverHttpAxios,
    auth: {
      request: function (req, token) {
        req.headers['Authorization'] = 'Bearer ' + token;
      },
      response: function (res) {
        if(res.data.access_token) {
          return res.data.access_token;
        }
      }
    },
    router: driverRouterVueRouter,
  },
  options: {
    rolesKey: 'role',
    notFoundRedirect: { name: 'home' },
    loginData: { url: 'login' },
    refreshTokenName: 'refresh_token',
    refreshData: { enabled: false },
    registerData: { url: 'register' },
    logoutData: { url: 'logout' },
    fetchData: { url: 'profile' },
    parseUserData: function(data) {
      return data;
    }
  }
});