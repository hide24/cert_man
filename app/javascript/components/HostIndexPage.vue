<template>
  <div id="app">
    <div class="row">
      <div class="col-sm">
        <b-button :to="{ name: 'HostNewPage' }" variant="primary">Create New Host</b-button>
      </div>
      <div class="col-sm">
        <div>search: <input type="text" v-model="select" placeholder="Host Name"></div>
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
      <tbody v-if="hosts.length">
        <tr>
          <th>ID</th>
          <th>Host Name</th>
          <th>Owner</th>
          <th>Certificate</th>
          <th>&nbsp;</th>
        </tr>
        <tr v-for="h in getItems">
          <td><router-link :to="{ name: 'HostDetailPage', params: { id: h.id } }">{{ h.id }}</router-link></td>
          <td><router-link :to="{ name: 'HostDetailPage', params: { id: h.id } }">{{ h.hostname }}</router-link></td>
          <td>{{ h.owner_name }}</td>
          <td>&nbsp;</td>
          <td>
            <b-button :to="{ name: 'HostDetailPage', params: { id: h.id } }" variant="outline-primary">View</b-button>
            <b-button :to="{ name: 'HostEditPage', params: { id: h.id } }" variant="outline-secondary">Edit</b-button>
            <b-button v-confirm="confirmDelete(h)" variant="outline-danger">Delete</b-button>
          </td>
        </tr>
      </tbody>
      <tbody v-else>
        <tr><td colspan="4">No Host Match.</td></tr>
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
      hosts: [],
      select: '',
      parPage: 5,
      currentPage: this.currentPage = this.$route.query.page || 1
    }
  },
  computed: {
    getItems() {
      let current = this.currentPage * this.parPage
      let start = current - this.parPage
      return this.hosts.slice(start, current)
    },
    getPageCount() {
      return Math.ceil(this.hosts.length / this.parPage)
    },
  },
  methods: {
    confirmDelete(host) {
      let self = this
      return {
        loader: true,
        html: true,
        okText: 'OK',
        cancelText: 'Cancel',
        backdropClose: true,
        ok(dialog) {
          self.deleteHost(dialog, host)
        },
        cancel() {
          console.log('canceled.')
        },
        message: {
          title: 'Delete Host',
          body: 'Are you sure? <br><br><strong>Name:</strong> '+ host.hostname
        }
      }
    },
    updateHost() {
      axios.get(`/hosts.json?query=${this.select}`, {withCredentials: true})
        .then(response => {
          this.hosts = response.data
        })
    },
    deleteHost(dialog, host) {
      console.log(`executed.0.${host.id}`)
      if(host.id > 0){
        axios
          .delete(`/hosts/${host.id}.json`)
          .then(response => {
            this.updateHost()
            this.$toasted.show('Host was successfully deleted.', {type: 'success'})
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
        name: 'HostIndexPage',
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
    this.updateHost()
  },
  watch:{
    select() {
      this.currentPage = 1
      this.updateHost()
      this.$router.push({
        name: 'HostIndexPage',
        query: this.buildQuery(),
      })
    },
  },
}
</script>

<style scoped>
</style>