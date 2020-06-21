<template>
  <div>
    <router-view></router-view>
  </div>
</template>

<script>
import Vue from 'vue'
import VueRouter from 'vue-router'

import OrganizationIndexPage from 'components/OrganizationIndexPage.vue'
import OrganizationDetailPage from 'components/OrganizationDetailPage.vue'
import OrganizationNewPage from 'components/OrganizationNewPage.vue'
import OrganizationEditPage from 'components/OrganizationEditPage.vue'

import axios from 'axios';
import { csrfToken } from '@rails/ujs'
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken()

import VueFormGenerator from "vue-form-generator"
import "vue-form-generator/dist/vfg.css"
Vue.component("VueFormGenerator", VueFormGenerator.component)


const router = new VueRouter({
  routes: [
    { path: '/',
      component: OrganizationIndexPage  },
    { path: '/organizations',
      name: 'OrganizationIndexPage',
      component: OrganizationIndexPage },
    { path: '/organizations/new',
      name: 'OrganizationNewPage',
      component: OrganizationNewPage },
    { path: '/organizations/:id(\\d+)',
      name: 'OrganizationDetailPage',
      component: OrganizationDetailPage },
    { path: '/organizations/:id(\\d+)/edit',
      name: 'OrganizationEditPage',
      component: OrganizationEditPage },
  ]
})

// ref. https://jp.vuejs.org/v2/guide/plugins.html#%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3%E3%81%AE%E4%BD%BF%E7%94%A8
Vue.use(VueRouter)

export default {
  router
}
</script>

<style scoped>
</style>