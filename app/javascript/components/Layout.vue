<template>
  <div :key="locale">
    <menu-link :changeLocale="changeLocale"></menu-link>
    <div class="row">
      <div class="col-sm-10 mx-auto">
        <router-view></router-view>
      </div>
    </div>
  </div>
</template>

<script>
import MenuLink from './MenuLink.vue'

export default {
  components: { MenuLink },
  data() {
    return {locale: 'ja'}
  },
  methods: {
    changeLocale(loc) {
      if(loc) {
        I18n.locale = loc
        this.locale = loc
      } else {
        this.locale = (this.locale === 'ja')? 'en': 'ja'
        I18n.locale = this.locale
      }
    },
  },
}
</script>

<style scoped>
</style>