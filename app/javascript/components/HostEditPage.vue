<template>
  <div id="app">
    <model-form modelName="host" api="hosts" :id="this.$route.params.id"></model-form>
  </div>
</template>

<script>
import ModelForm from './ModelForm.vue'

export default {
  components: { ModelForm },
  data() {
    return {
    }
  },
}
</script>

<style scoped>
</style>