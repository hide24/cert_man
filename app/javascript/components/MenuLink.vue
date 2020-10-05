<template>
  <div class="contents">
    <b-navbar toggleable="md" type="dark" variant="info">

      <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

      <b-navbar-brand href="#">{{ t('layouts.navi_bar.title') }}</b-navbar-brand>

      <b-collapse is-nav id="nav_collapse">

        <b-navbar-nav>
          <b-nav-item :to="{ name: 'CertificateApplicationIndexPage' }" :class="isActive('CertificateApplication')">
            {{ t('layouts.navi_bar.certificate_applications') }}
          </b-nav-item>
          <b-nav-item :to="{ name: 'HostIndexPage' }" :class="isActive('Host')">
            {{ t('layouts.navi_bar.hosts') }}
          </b-nav-item>
          <b-nav-item :to="{ name: 'OrganizationIndexPage' }" :class="isActive('Organization')">
            {{ t('layouts.navi_bar.organizations') }}
          </b-nav-item>
        </b-navbar-nav>

        <!-- Right aligned nav items -->
        <b-navbar-nav class="ml-auto">

          <b-nav-item-dropdown :text="t('layouts.navi_bar.languages')" right>
            <b-dropdown-item href="#" @click="changeLocale('en')">{{ t('layouts.navi_bar.english') }}</b-dropdown-item>
            <b-dropdown-item href="#" @click="changeLocale('ja')">{{ t('layouts.navi_bar.japanese') }}</b-dropdown-item>
          </b-nav-item-dropdown>

          <b-nav-item right rel="nofollow" data-method="delete" href="/users/sign_out">{{ t('layouts.navi_bar.logout') }}
          </b-nav-item>
        </b-navbar-nav>

      </b-collapse>
    </b-navbar>
    <div class="row">&nbsp;</div>
  </div>
</template>

<script>
export default {
  props: {
    changeLocale: Function
  },
  data() {
    return {
    }
  },
  methods: {
    buttonClass(page) {
      let klass = 'outline-primary'
      const matcher = new RegExp('^' + page)
      if(matcher.test(this.$route.name)) { klass = 'primary'}
      return klass
    },
    isActive(page) {
      let klass = ''
      const matcher = new RegExp('^' + page)
      if(matcher.test(this.$route.name)) { klass = 'active'}
      return klass
    },
  },
}
</script>

<style>
</style>
