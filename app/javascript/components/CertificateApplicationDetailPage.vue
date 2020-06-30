<template>
  <div id="app">
    <div class="row"  v-if="getPageCount > 1">
      <div class="col-sm">
        <div class="float-right">
          <paginate-link :currentPage="currentPage" :pageCount="getPageCount" @changePage="changePage($event)"></paginate-link>
        </div>
      </div>
    </div>
    <table class="table table-striped table-bordered">
      <tbody v-if="certificates.length">
        <tr>
          <th>Hostname</th>
          <th>Expiration Date</th>
          <th>&nbsp;</th>
        </tr>
        <tr v-for="c in getItems">
          <td><router-link :to="{ name: 'HostDetailPage', params: { id: c.host_id } }">{{ c.hostname }}</router-link></td>
          <td :class="`table-${c.expiration_date_class}`">{{ c.expiration_date }}</td>
          <td>
            <b-button :href="`/certificates/${c.id}.key`" variant="outline-primary">Private Key</b-button>
            <b-button :href="`/certificates/${c.id}.csr`" variant="outline-primary">Certificate Request</b-button>
            <b-button :href="`/certificates/${c.id}.cer`" variant="outline-primary" v-if="!(c.expiration_date === 'in progress')">Certificate</b-button>
          </td>
        </tr>
      </tbody>
      <tbody v-else>
        <tr><td colspan="4">No Certificate Found.</td></tr>
      </tbody>
    </table>
    <div class="row" v-if="getPageCount > 1">
      <div class="col-sm">
        <div class="float-right">
          <paginate-link :currentPage="currentPage" :pageCount="getPageCount" @changePage="changePage($event)"></paginate-link>
        </div>
      </div>
    </div>
    <ul>
      <li>Created at: {{ certificate_application.created_at }}</li>
      <li>Updated at: {{ certificate_application.created_at }}</li>
      <a :href="`/certificate_applications/${this.$route.params.id}.tsv`">download tsv</a>
      <a :href="`/certificate_applications/${this.$route.params.id}.zip`">download zip</a>
    </ul>
    <upload-certificate-form :id="this.$route.params.id" @uploaded="updateCertifications($event)"
     v-if="isInProgress"></upload-certificate-form>

    <div class="mx-auto" style="width: 200px;">
      <b-button @click="$router.go(-1)" variant="outline-secondary">Back</b-button>
    </div>

  </div>
</template>

<script>
import axios from 'axios'
import PaginateLink from './PaginateLink.vue'
import UploadCertificateForm from './UploadCertificateForm.vue'

export default {
  components: { PaginateLink, UploadCertificateForm },
  data() {
    return {
      certificate_application: {},
      certificates: [],
      parPage: 5,
      currentPage: this.currentPage = this.$route.query.page || 1
    }
  },
  computed: {
    getItems() {
      let current = this.currentPage * this.parPage
      let start = current - this.parPage
      return this.certificates.slice(start, current)
    },
    getPageCount() {
      return Math.ceil(this.certificates.length / this.parPage)
    },
  },
  methods: {
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
    isInProgress() {
      this.certificates.even(c => c.expiration_date === 'in progress')
    },
    updateCertifications(item) {
      axios.get(`/certificate_applications/${this.$route.params.id}/certificates.json`, {withCredentials: true})
      .then(response => {
        this.certificates = response.data
      })
    },
  },
  mounted() {
    axios.get(`/certificate_applications/${this.$route.params.id}.json`, {withCredentials: true})
      .then(response => {
        this.certificate_application = response.data
      })
    axios.get(`/certificate_applications/${this.$route.params.id}/certificates.json`, {withCredentials: true})
      .then(response => {
        this.certificates = response.data
      })

  },
}
</script>

<style scoped>
</style>