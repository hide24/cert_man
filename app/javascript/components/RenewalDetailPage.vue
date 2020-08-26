<template>
  <div id="app">
    <model-form modelName="renewal" :api='`hosts/${this.$route.params.id}/renewal`' schemaApi="renewal" id="single"></model-form>
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