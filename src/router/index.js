import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '../components/Login.vue'
import Home from '../components/Home.vue'
import Welcome from '../components/Welcome.vue'
import Info from '../components/Info.vue'
import SetPassword from '../components/SetPassword.vue'
import Stock from '../components/Stock.vue'
import Stockchart from '../components/Stockchart.vue'
import Goods from '../components/Goods.vue'
import Admin from '../components/Admin.vue'
import Adv from '../components/Adv.vue'

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
      { path: '/stock', component: Stock },
      { path: '/stockchart', component: Stockchart },
      { path: '/goods', component: Goods },
      { path: '/admin', component: Admin },
      { path: '/adv', component: Adv},
    ]
  }
]

const router = new VueRouter({
  routes
})

export default router
