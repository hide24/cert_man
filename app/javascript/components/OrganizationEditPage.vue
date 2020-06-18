<template>
  <div id="app">
    Edit
    <organization-form :model="model"></organization-form>
  </div>
</template>

<script>
import axios from 'axios';
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

  mounted () {
    axios.get(`/organizations/${this.$route.params.id}.json`, {withCredentials: true})
      .then(response => this.model.organization = response.data)
  }
}
</script>

<style scoped>
</style>