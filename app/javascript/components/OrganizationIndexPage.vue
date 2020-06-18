<template>
  <div id="app">
    <b-button :to="{ name: 'OrganizationNewPage' }" variant="primary">Create New Organization</b-button>

    <paginate-link :currentPage="currentPage" :pageCount="getPageCount" @changePage="changePage($event)"></paginate-link>

    <table class="table table-striped table-bordered">
      <tbody>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>DN</th>
          <th>&nbsp;</th>
        </tr>
        <tr v-for="o in getItems">
          <td><router-link :to="{ name: 'OrganizationDetailPage', params: { id: o.id } }">{{ o.id }}</router-link></td>
          <td><router-link :to="{ name: 'OrganizationDetailPage', params: { id: o.id } }">{{ o.name }}</router-link></td>
          <td>{{ o | to_dn }}</td>
          <td>
            <b-button :to="{ name: 'OrganizationDetailPage', params: { id: o.id } }" variant="outline-primary">View</b-button>
            <b-button :to="{ name: 'OrganizationEditPage', params: { id: o.id } }" variant="outline-secondary">Edit</b-button>
            <b-button v-confirm="confirmDelete(o)" variant="outline-danger">Delete</b-button>
          </td>
        </tr>
      </tbody>
    </table>

    <paginate-link :currentPage="currentPage" :pageCount="getPageCount" @changePage="changePage($event)"></paginate-link>

  </div>
</template>

<script>
import axios from 'axios';
import Paginate from 'vuejs-paginate'
import PaginateLink from './PaginateLink.vue'

export default {
  components: {
    Paginate,
    PaginateLink
  },
  data: function () {
    return {
      organizations: [],
      parPage: 5,
      currentPage: 1,
    }
  },
  computed: {
    getItems() {
      let current = this.currentPage * this.parPage
      let start = current - this.parPage
      return this.organizations.slice(start, current)
    },
    getPageCount() {
      return Math.ceil(this.organizations.length / this.parPage)
    },
  },
  methods: {
    confirmDelete(organization) {
      let self = this
      return {
        loader: true,
        html: true,
        okText: 'OK',
        cancelText: 'Cancel',
        backdropClose: true,
        ok: function(dialog) {
          self.deleteOrganization(dialog, organization)
        },
        cancel: function() {
          console.log('canceled.')
        },
        message: {
          title: 'Delete Organization',
          body: 'Are you sure? <br><br><strong>Name:</strong> '+ organization.name
        }
      }
    },
    updateOrganization() {
      axios.get('/organizations.json', {withCredentials: true})
        .then(response => this.organizations = response.data)
    },
    deleteOrganization(dialog, organization) {
      console.log(`executed.0.${organization.id}`)
      if(organization.id > 0){
        axios
          .delete(`/organizations/${organization.id}.json`)
          .then(response => {
            this.updateOrganization()
            dialog.close()
          })
          .catch(error => {
            console.error(error)
//            if (error.response.data && error.response.data.errors) {
//            this.errors = error.response.data.errors;
//            }
          })
      }
      console.log('executed.');
    },
    changePage(pageNum) {
      this.currentPage = Number(pageNum)
    },
  },
  mounted () {
    this.updateOrganization()
  },

  filters: {
    to_dn(o) {
      var dn_str = ""
      if(o.country) { dn_str += `/C=${o.country}`}
      if(o.state) { dn_str += `/ST=${o.state}`}
      if(o.locality) { dn_str += `/L=${o.locality}`}
      if(o.county) { dn_str += `/C=${o.country}`}
      if(o.organization) { dn_str += `/O=${o.organization}`}
      if(o.unit) { dn_str += `/OU=${o.unit}`}
      return dn_str
    }
  }
}
</script>

<style scoped>
</style>