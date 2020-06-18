<template>
  <div id="app">
    <organization-detail :organization="organization"></organization-detail>
    <router-link :to="{ name: 'OrganizationIndexPage' }">Back</router-link>
  </div>
</template>

<script>
import axios from 'axios';
import OrganizationDetail from './OrganizationDetail.vue'

export default {
  components: { OrganizationDetail },

  data: function () {
    return {
      organization: {},
    }
  },

  mounted () {
    axios.get(`/organizations/${this.$route.params.id}.json`)
      .then(response => this.organization = response.data)
  }
}
</script>

<style scoped>
</style>