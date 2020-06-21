<template>
  <div id="app">
    <host-form :model="model"></host-form>
  </div>
</template>

<script>
import axios from 'axios';
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
}
</script>

<style scoped>
</style>