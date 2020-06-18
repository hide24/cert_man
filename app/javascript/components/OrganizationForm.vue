<template>
  <div class="panel-body">
    <form @submit.prevent="updateOrganization">
      <div v-if="errors.length != 0">
        <ul v-for="e in errors" :key="e">
          <li><font color="red">{{ e }}</font></li>
        </ul>
      </div>
      <vue-form-generator :schema="schema" :model="model" :options="formOptions"  @validated="onValidated"></vue-form-generator>
      <div class="mx-auto" style="width: 200px;">
        <b-button :to="{ name: 'OrganizationIndexPage' }" variant="outline-secondary">Back</b-button>
        <b-button type="submit" variant="primary" :disabled="!isValid">Commit</b-button>
      </div>
    </form>
  </div>
</template>

<script>
import axios from 'axios';
import VueFormGenerator from "vue-form-generator";
import "vue-form-generator/dist/vfg.css"; 

export default {
  components: {
    "vue-form-generator": VueFormGenerator.component
  },
  props: ["model"],
  data: function () {
    return {
      isValid: false,
      errors: "",

      schema: {
        fields: [
          {
            type: "input",
            inputType: "text",
            label: "Name",
            model: "organization.name",
            inputName: "organization[name]",
            readonly: false,
            featured: true,
            required: true,
            disabled: false,
            placeholder: "Name",
            validator: VueFormGenerator.validators.string
          }, {
            type: "input",
            inputType: "text",
            label: "Country",
            model: "organization.country",
            inputName: "organization[country]",
            readonly: false,
            featured: true,
            required: true,
            disabled: false,
            placeholder: "",
            validator: VueFormGenerator.validators.string
          }, {
            type: "input",
            inputType: "text",
            label: "state",
            model: "organization.state",
            inputName: "organization[state]",
            readonly: false,
            featured: true,
            required: true,
            disabled: false,
            placeholder: "",
            validator: VueFormGenerator.validators.string
          }, {
            type: "input",
            inputType: "text",
            label: "locality",
            model: "organization.locality",
            inputName: "organization[locality]",
            readonly: false,
            featured: true,
            required: true,
            disabled: false,
            placeholder: "",
            validator: VueFormGenerator.validators.string
          }, {
            type: "input",
            inputType: "text",
            label: "Organization",
            model: "organization.organization",
            inputName: "organizationorganization",
            readonly: false,
            featured: true,
            required: true,
            disabled: false,
            placeholder: "",
            validator: VueFormGenerator.validators.string
          }, {
            type: "input",
            inputType: "text",
            label: "Organizational Unit",
            model: "organization.unit",
            inputName: "organization[unit]",
            readonly: false,
            featured: true,
            required: false,
            disabled: false,
            placeholder: "",
            validator: VueFormGenerator.validators.string
          }, {
            type: "input",
            inputType: "text",
            label: "Mail",
            model: "organization.mail",
            inputName: "organization[mail]",
            readonly: false,
            featured: true,
            required: false,
            disabled: false,
            placeholder: "",
            validator: VueFormGenerator.validators.string
          }
        ]
      },
      formOptions: {
        validateAfterLoad: false,
        validateAfterChanged: true
      }
    }
  },

  methods: {
    updateOrganization() {
      if(this.model.organization.id) {
        axios
        .put(`/organizations/${this.model.organization.id}.json`, this.model)
        .then(response => {
          let e = response.data;
          this.$router.push({ name: 'OrganizationDetailPage', params: { id: e.id } });
        })
        .catch(error => {
          console.error(error);
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        });
      } else {
        axios
        .post(`/organizations.json`, this.model)
        .then(response => {
          let e = response.data;
          this.$router.push({ name: 'OrganizationDetailPage', params: { id: e.id } });
        })
        .catch(error => {
          console.error(error);
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        });
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