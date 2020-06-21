<template>
  <div id="app">
    <organization-form :model="model" :schema="schema"></organization-form>
  </div>
</template>

<script>
import OrganizationForm from './OrganizationForm.vue'

export default {
  components: { OrganizationForm },
  data() {
    return {
      model: {
        organization: {
        }
      },
      schema: {},
    }
  },
  mounted() {
    axios.get(`/organizations/schema`, {withCredentials: true})
      .then(response => this.schema = response.data)
  }
}
</script>

<style scoped>
</style>