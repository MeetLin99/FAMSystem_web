import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '../components/Login.vue'
import Home from '../components/Home.vue'
import Welcome from '../components/Welcome.vue'
import Info from '../components/Info.vue'
import SetPassword from '../components/SetPassword.vue'
import News from '../components/News.vue'

Vue.use(VueRouter)
const routes = [
  { path: '/', redirect: '/login' },
  { path: '/login', component: Login },
  {
    path: '/home',
    component: Home,
    redirect: '/welcome',
    children: [
      { path: '/welcome', component: Welcome },
      { path: '/info', component: Info },
      { path: '/setPassword', component: SetPassword },
      { path: '/news', component: News }
    ]
  }
]

const router = new VueRouter({
  routes
})

export default router
