<template>
  <div id="app">
    <host-form :id="this.$route.params.id" :readonly="true"></host-form>
  </div>
</template>

<script>
import HostForm from './HostForm.vue'

export default {
  components: { HostForm },
  data() {
    return {
    }
  },
}
</script>

<style scoped>
</style>