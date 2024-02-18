import { ref } from "vue";
import {toast} from "vue3-toastify";

export default () => {
  const errors = ref([])

  const getError = field => {
    if (errors.value) {
      const error = errors.value.find(item => item.field === field)
      if (error && error.message) {
        return error.message.charAt(0).toUpperCase() + error.message.slice(1)
      }
    }
  };

  const handleErrors = error => {
    if (error.response) {
      if (error.response.data.errors) {
        if (error.response.data.errors.find(error => error.message?.includes('E_UNAUTHORIZED_ACCESS'))) {
          toast.error(error.response.data.errors[0].message.split('E_UNAUTHORIZED_ACCESS: ').join(''))
        } else {
          errors.value = error.response.data.errors
        }
      } else if (error.response.data.message) {
        toast.error(error.response.data.message)
      }
    } else {
      toast.error(error.message)
    }
  }

  return {
    errors,
    getError,
    handleErrors
  }
};
