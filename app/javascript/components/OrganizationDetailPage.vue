<template>
  <div id="app">
    <model-form modelName="organization" api="organizations" :id="this.$route.params.id" :readonly="true"></model-form>
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