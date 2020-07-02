<template>
  <div>
    <menu-link></menu-link>
    <router-view></router-view>
    <a rel="nofollow" data-method="delete" href="/users/sign_out">{{ t('logout')}}</a>
  </div>
</template>

<script>

import MenuLink from './MenuLink.vue'

export default {
  components: { MenuLink },
}
</script>

<style scoped>
</style>