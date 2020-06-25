<template>
  <div class="panel-body">
    <form @submit.prevent="submitHost">
      <div v-if="errors.length != 0">
        <ul v-for="e in errors" :key="e">
          <li><font color="red">{{ e }}</font></li>
        </ul>
      </div>
      <vue-form-generator :schema="schema" :model="host" :options="formOptions"  @validated="onValidated"></vue-form-generator>
      <div class="mx-auto" style="width: 200px;">
        <b-button @click="$router.go(-1)" variant="outline-secondary">Back</b-button>
        <b-button type="submit" variant="primary" :disabled="!isValid" v-if="!readonly">{{ submitButton }}</b-button>
      </div>
    </form>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  props: ["id", "readonly"],
  data() {
    return {
      host: {},
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
      let button = 'Create'
      if(this.id) { button = 'Update'}
      return button
    }
  },
  mounted() {
    axios.get(`/hosts/schema?readonly=${this.readonly}`, {withCredentials: true})
      .then(response => this.schema = response.data)
    if(this.id) {
      axios.get(`/hosts/${this.id}.json`, {withCredentials: true})
        .then(response => this.host = response.data)
    }
  },
  methods: {
    submitHost() {
      if(this.host.id) {
        // update
        axios
        .put(`/hosts/${this.host.id}.json`, {host: this.host})
        .then(response => {
          let e = response.data
          this.$toasted.show('Host was successfully updated.', {type: 'success'})
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
        .post(`/hosts.json`, {host: this.host})
        .then(response => {
          let e = response.data
          this.$toasted.show('Host was successfully created.', {type: 'success'})
          this.$router.push({ name: 'HostIndexPage' })
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