import Vue from 'vue'
import App from './App.vue'
import router from './router'
import './plugins/element.js'
import './assets/css/global.css'
import QuillEditor from 'vue-quill-editor'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.bubble.css'
import 'quill/dist/quill.snow.css'

import axios from 'axios'
import qs from 'qs'
Vue.prototype.$qs = qs
// 配置请求的根路径
axios.defaults.baseURL = 'http://localhost:8848/api'
Vue.prototype.$http = axios

Vue.config.productionTip = false
// 使用富文本编辑器
Vue.use(QuillEditor)

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
