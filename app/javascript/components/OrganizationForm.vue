<template>
  <div class="panel-body">
    <form @submit.prevent="submitOrganization">
      <div v-if="errors.length != 0">
        <ul v-for="e in errors" :key="e">
          <li><font color="red">{{ e }}</font></li>
        </ul>
      </div>
      <vue-form-generator :schema="schema" :model="model" :options="formOptions"  @validated="onValidated"></vue-form-generator>
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
  props: ["model", "readonly"],
  data() {
    return {
      isValid: false,
      errors: "",

      schema: {
        groups: [
        {
          legend: 'Organization Info',
          fields: [
            {
              type: "input",
              inputType: "text",
              label: "Name",
              model: "organization.name",
              inputName: "organization[name]",
              readonly: this.readonly,
              featured: true,
              required: true,
              disabled: false,
              placeholder: "Name",
              validator: "string"
            },
          ]
        },
        {
          legend: 'Domain Name Info',
          fields: [
            {
              type: "input",
              inputType: "text",
              label: "Country",
              model: "organization.country",
              inputName: "organization[country]",
              readonly: this.readonly,
              featured: true,
              required: true,
              disabled: false,
              placeholder: "",
              validator: "string"
            }, {
              type: "input",
              inputType: "text",
              label: "state",
              model: "organization.state",
              inputName: "organization[state]",
              readonly: this.readonly,
              featured: true,
              required: true,
              disabled: false,
              placeholder: "",
              validator: "string"
            }, {
              type: "input",
              inputType: "text",
              label: "locality",
              model: "organization.locality",
              inputName: "organization[locality]",
              readonly: this.readonly,
              featured: true,
              required: true,
              disabled: false,
              placeholder: "",
              validator: "string"
            }, {
              type: "input",
              inputType: "text",
              label: "Organization",
              model: "organization.organization",
              inputName: "organizationorganization",
              readonly: this.readonly,
              featured: true,
              required: true,
              disabled: false,
              placeholder: "",
              validator: "string"
            }, {
              type: "input",
              inputType: "text",
              label: "Organizational Unit",
              model: "organization.unit",
              inputName: "organization[unit]",
              readonly: this.readonly,
              featured: true,
              required: false,
              disabled: false,
              placeholder: "",
              validator: "string"
            }, {
              type: "input",
              inputType: "text",
              label: "Mail",
              model: "organization.mail",
              inputName: "organization[mail]",
              readonly: this.readonly,
              featured: true,
              required: false,
              disabled: false,
              placeholder: "",
              validator: "string"
            }
          ],
        },
        ]
      },
      formOptions: {
        validateAfterLoad: false,
        validateAfterChanged: true
      }
    }
  },
  computed: {
    submitButton() {
      let button = 'Create'
      if(this.model.organization.id) { button = 'Update'}
      return button
    }
  },
  methods: {
    submitOrganization() {
      if(this.model.organization.id) {
        // update
        axios
        .put(`/organizations/${this.model.organization.id}.json`, this.model)
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
        });
      } else {
        // create
        axios
        .post(`/organizations.json`, this.model)
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