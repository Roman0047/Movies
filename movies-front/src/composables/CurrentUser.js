import {computed} from "vue";
import {useAuth} from "@websanova/vue-auth";

export default () => {
  const $auth = useAuth()

  const isAdmin = computed(() => {
    return $auth.user() && $auth.user().role === 'admin'
  })

  const user = computed(() => $auth.user())

  return {
    isAdmin,
    user
  }
};
