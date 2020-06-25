<template>
  <div class="panel-body">
    <form @submit.prevent="submitOrganization">
      <div v-if="errors.length != 0">
        <ul v-for="e in errors" :key="e">
          <li><font color="red">{{ e }}</font></li>
        </ul>
      </div>
      <vue-form-generator :schema="schema" :model="organization" :options="formOptions"  @validated="onValidated"></vue-form-generator>
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
      organization: {},
      isValid: false,
      errors: "",
      schema: {},
      formOptions: {
        validateAfterLoad: true,
        validateAfterChanged: true
      }
    }
  },
  mounted() {
    axios.get(`/organizations/schema?readonly=${this.readonly}`, {withCredentials: true})
      .then(response => this.schema = response.data)
    if(this.id) {
      axios.get(`/organizations/${this.id}.json`, {withCredentials: true})
        .then(response => this.organization = response.data)
    }
  },
  computed: {
    submitButton() {
      let button = 'Create'
      if(this.id) { button = 'Update'}
      return button
    }
  },
  methods: {
    submitOrganization() {
      if(this.organization.id) {
        // update
        axios
        .put(`/organizations/${this.organization.id}.json`, {organization: this.organization})
        .then(response => {
          let e = response.data
          this.$toasted.show('Organization was successfully updated.', {type: 'success'})
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
        .post(`/organizations.json`, {organization: this.organization})
        .then(response => {
          let e = response.data
          this.$toasted.show('Organization was successfully created.', {type: 'success'})
          this.$router.push({ name: 'OrganizationIndexPage' })
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