<template>
  <div class="contents">
    <div class="row">
      <div class="col-sm">
        <b-button :to="{ name: 'CertificateApplicationIndexPage' }" :variant="buttonClass('CertificateApplication')">{{ t('activerecord.models.certificate_application') }}</b-button>
        <b-button :to="{ name: 'HostIndexPage' }" :variant="buttonClass('Host')">{{ t('activerecord.models.host') }}</b-button>
        <b-button :to="{ name: 'OrganizationIndexPage' }" :variant="buttonClass('Organization')">{{ t('activerecord.models.organization') }}</b-button>
      </div>
    </div>
    <div class="row">&nbsp;</div>
  </div>
</template>

<script>
export default {
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
  },
}
</script>

<style>
</style>
