import 'vuetify/styles'
// import '@mdi/font/css/materialdesignicons.css' // Connect mdi icons as a link in index.html file it saves 1.8 seconds of First Contentful Paint and Largest Contentful Paint but ads 100 ms to Total Blocking Time
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'

export default createVuetify({
  components,
  directives,
  theme: {
    defaultTheme: 'dark'
  }
})