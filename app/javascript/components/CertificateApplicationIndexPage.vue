<template>
  <div id="app">
    <div class="row">
      <div class="col-sm">
        <b-button :to="{ name: 'HostIndexPage' }" variant="primary">Create New Application</b-button>
      </div>
      <div class="col-sm">
        <div>search: <input type="text" v-model="select" placeholder="Application Name"></div>
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
      <tbody v-if="certificate_applications.length">
        <tr>
          <th>ID</th>
          <th>Status</th>
          <th>Created at</th>
          <th>Updated at</th>
          <th>&nbsp;</th>
        </tr>
        <tr v-for="a in getItems">
          <td><router-link :to="{ name: 'CertificateApplicationDetailPage', params: { id: a.id } }">{{ a.id }}</router-link></td>
          <td><router-link :to="{ name: 'CertificateApplicationDetailPage', params: { id: a.id } }">in progress</router-link></td>
          <td>{{ a.created_at }}</td>
          <td>{{ a.updated_at }}</td>
          <td>
            <b-button :to="{ name: 'CertificateApplicationDetailPage', params: { id: a.id } }" variant="outline-primary">Detail</b-button>
            <b-button v-confirm="confirmDelete(a)" variant="outline-danger">Delete</b-button>
          </td>
        </tr>
      </tbody>
      <tbody v-else>
        <tr><td colspan="4">No Application Match.</td></tr>
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
import axios from 'axios';
import PaginateLink from './PaginateLink.vue'

export default {
  components: { PaginateLink },
  data() {
    return {
      errors: '',
      certificate_applications: [],
      select: '',
      parPage: 5,
      currentPage: this.currentPage = this.$route.query.page || 1
    }
  },
  computed: {
    getItems() {
      let current = this.currentPage * this.parPage
      let start = current - this.parPage
      return this.certificate_applications.slice(start, current)
    },
    getPageCount() {
      return Math.ceil(this.certificate_applications.length / this.parPage)
    },
  },
  methods: {
    confirmDelete(certificate_application) {
      let self = this
      return {
        loader: true,
        html: true,
        okText: 'OK',
        cancelText: 'Cancel',
        backdropClose: true,
        ok(dialog) {
          self.deleteCertificateApplication(dialog, certificate_application)
        },
        cancel() {
          console.log('canceled.')
        },
        message: {
          title: 'Delete CertificateApplication',
          body: 'Are you sure?'
        }
      }
    },
    updateCertificateApplication() {
      axios.get(`/certificate_applications.json?query=${this.select}`, {withCredentials: true})
        .then(response => this.certificate_applications = response.data)
    },
    deleteCertificateApplication(dialog, certificate_application) {
      console.log(`executed.0.${certificate_application.id}`)
      if(certificate_application.id > 0){
        axios
          .delete(`/certificate_applications/${certificate_application.id}.json`)
          .then(response => {
            this.updateCertificateApplication()
            this.$toasted.show('Application was successfully deleted.', {type: 'success'})
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
        name: 'CertificateApplicationIndexPage',
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
    this.updateCertificateApplication()
  },
  watch:{
    select() {
      this.currentPage = 1
      this.updateCertificateApplication()
      this.$router.push({
        name: 'CertificateApplicationIndexPage',
        query: this.buildQuery(),
      })
    },
  },
}
</script>

<style scoped>
</style>