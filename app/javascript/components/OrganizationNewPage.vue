<template>
  <div id="app">
    New
    <organization-form :model="model"></organization-form>
  </div>
</template>

<script>
import OrganizationForm from './OrganizationForm.vue'

export default {
  components: { OrganizationForm },

  data: function () {
    return {
      model: {
        organization: {
        }
      }
    }
  },
}
</script>

<style scoped>
</style>