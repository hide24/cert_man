<template>
  <div id="app">
    <organization-form :id="this.$route.params.id"></organization-form>
  </div>
</template>

<script>
import OrganizationForm from './OrganizationForm.vue'

export default {
  components: { OrganizationForm },
  data() {
    return {
    }
  },
}
</script>

<style scoped>
</style>