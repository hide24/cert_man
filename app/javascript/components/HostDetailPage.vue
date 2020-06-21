<template>
  <div id="app">
    <host-form :model="model" :readonly="true"></host-form>
  </div>
</template>

<script>
import axios from 'axios'
import HostForm from './HostForm.vue'

export default {
  components: { HostForm },

  data() {
    return {
      model: {
        host: {
        }
      },
    }
  },
  mounted() {
    axios.get(`/hosts/${this.$route.params.id}.json`, {withCredentials: true})
      .then(response => this.model.host = response.data)
  }
}
</script>

<style scoped>
</style>