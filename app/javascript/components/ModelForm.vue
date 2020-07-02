<template>
  <div class="panel-body">
    <form @submit.prevent="submitModel">
      <div v-if="errors.length != 0">
        <ul v-for="e in errors" :key="e">
          <li><font color="red">{{ e }}</font></li>
        </ul>
      </div>
      <vue-form-generator :schema="schema" :model="model" :options="formOptions"  @validated="onValidated"></vue-form-generator>
      <div class="mx-auto" style="width: 200px;">
        <b-button @click="$router.go(-1)" variant="outline-secondary" v-if="!hideBack">{{ t('back') }}</b-button>
        <b-button type="submit" variant="primary" :disabled="!isValid" v-if="!readonly">{{ submitButton }}</b-button>
      </div>
    </form>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  props: ["modelName", "api", "id", "readonly", "hideBack"],
  data() {
    return {
      model: {},
      isValid: false,
      errors: "",
      schema: {},
      formOptions: {
        validateAfterLoad: true,
        validateAfterChanged: true
      },
    }
  },
  computed: {
    submitButton() {
      let button = this.t('create')
      if(this.id) { button = this.t('update')}
      return button
    }
  },
  mounted() {
    axios.get(`/${this.api}/schema?readonly=${this.readonly}&locale=${this.currentLocale()}`, {withCredentials: true})
      .then(response => this.schema = response.data)
    if(this.id) {
      axios.get(`/${this.api}/${this.id}.json`, {withCredentials: true})
        .then(response => this.model = response.data)
    }
  },
  methods: {
    submitModel() {
      let body = {}
      body[this.modelName] = this.model
      if(this.model.id) {
        // update
        axios
        .put(`/${this.api}/${this.model.id}.json`, body)
        .then(response => {
          let e = response.data
          this.$toasted.show(`${this.modelName} was successfully updated.`, {type: 'success'})
          this.$router.go(-1)
        })
        .catch(error => {
          console.error(error)
          if (error.response.data && error.response.data.errors) {
            this.$toasted.show('Error occurred.', {type: 'error'})
            this.errors = error.response.data.errors
          }
        })
      } else {
        // create
        axios
        .post(`/${this.api}.json`, body)
        .then(response => {
          let e = response.data
          this.$toasted.show(`${this.modelName} was successfully created.`, {type: 'success'})
          this.$router.go(-1)
        })
        .catch(error => {
          console.error(error)
          if (error.response.data && error.response.data.errors) {
            this.$toasted.show('Error occurred.', {type: 'error'})
            this.errors = error.response.data.errors
          }
        })
      }
    },
    onValidated(isValid, errors) {
      this.isValid = isValid
    },
  },
}
</script>

<style scoped>
</style>