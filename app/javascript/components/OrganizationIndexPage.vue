<template>
  <div id="app">
    <div class="row">
      <div class="col-sm">
        <b-button :to="{ name: 'OrganizationNewPage' }" variant="primary">Create New Organization</b-button>
      </div>
      <div class="col-sm">
        <div>search: <input type="text" v-model="select" placeholder="Organization Name"></div>
      </div>
      <div class="col-sm">
        <div class="float-right">
          <paginate-link :currentPage="currentPage" :pageCount="getPageCount" @changePage="changePage($event)"></paginate-link>
        </div>
      </div>
    </div>

    <div v-if="errors.length != 0">
      <ul v-for="e in errors" :key="e">
        <li><font color="red">{{ e }}</font></li>
      </ul>
    </div>
    <table class="table table-striped table-bordered">
      <tbody v-if="organizations.length">
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>DN</th>
          <th>&nbsp;</th>
        </tr>
        <tr v-for="o in getItems">
          <td><router-link :to="{ name: 'OrganizationDetailPage', params: { id: o.id } }">{{ o.id }}</router-link></td>
          <td><router-link :to="{ name: 'OrganizationDetailPage', params: { id: o.id } }">{{ o.name }}</router-link></td>
          <td>{{ o.dn }}</td>
          <td>
            <b-button :to="{ name: 'OrganizationDetailPage', params: { id: o.id } }" variant="outline-primary">View</b-button>
            <b-button :to="{ name: 'OrganizationEditPage', params: { id: o.id } }" variant="outline-secondary">Edit</b-button>
            <b-button @click="confirmDelete(o)" variant="outline-danger">Delete</b-button>
          </td>
        </tr>
      </tbody>
      <tbody v-else>
        <tr><td colspan="4">No Organization Match.</td></tr>
      </tbody>
    </table>

    <div class="row">
      <div class="col-sm">
        <div class="float-right">
          <paginate-link :currentPage="currentPage" :pageCount="getPageCount" @changePage="changePage($event)"></paginate-link>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import axios from 'axios'
import PaginateLink from './PaginateLink.vue'

export default {
  components: { PaginateLink },
  data() {
    return {
      errors: '',
      organizations: [],
      select: '',
      parPage: 5,
      currentPage: this.currentPage = this.$route.query.page || 1
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
    updateOrganization() {
      axios.get(`/organizations.json?query=${this.select}`, {withCredentials: true})
        .then(response => this.organizations = response.data)
    },
    confirmDelete(organization) {
      let self = this
      this.$dialog.confirm({
        title: 'Delete Organization',
        body: 'Are you sure? <br><br><strong>Name:</strong> '+ organization.name
      },{
        loader: true,
        html: true,
        okText: 'OK',
        cancelText: 'Cancel',
        backdropClose: true,
      })
      .then(dialog => self.deleteOrganization(dialog, organization))
    },
    deleteOrganization(dialog, organization) {
      console.log(`executed.0.${organization.id}`)
      if(organization.id > 0){
        axios
        .delete(`/organizations/${organization.id}.json`)
        .then(response => {
          this.updateOrganization()
          this.$toasted.show('Organization was successfully deleted.', {type: 'success'})
          this.changePage(1)
          dialog.close()
        })
        .catch(error => {
          console.error(error)
          this.$toasted.show('Error occurred.', {type: 'error'})
          if (error.response.data && error.response.data.errors) {
          this.errors = error.response.data.errors;
          }
        })
      }
      console.log('executed.');
    },
    changePage(pageNum) {
      this.currentPage = Number(pageNum)
      this.$router.push({
        name: 'OrganizationIndexPage',
        query: this.buildQuery(),
      })
    },
    buildQuery() {
      let q = {}
      if(this.currentPage > 1) {q.page = this.currentPage}
      if(this.select.length > 1) {q.select = this.select}
      return q
    },
  },
  mounted() {
    this.updateOrganization()
  },
  watch: {
    select() {
      this.currentPage = 1
      this.updateOrganization()
      this.$router.push({
        name: 'OrganizationIndexPage',
        query: this.buildQuery(),
      })
    },
  },
}
</script>

<style scoped>
</style>