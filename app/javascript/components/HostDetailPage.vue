<template>
  <div id="app">
    <model-form modelName="host" api="hosts" :id="this.$route.params.id" :readonly="true"></model-form>

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
          <th>{{ ta('certificate', 'version') }}</th>
          <th>Expiration Date</th>
          <th>&nbsp;</th>
        </tr>
        <tr v-for="c in getItems">
          <td><router-link :to="{ name: 'HostDetailPage', params: { id: c.id } }">{{ c.version }}</router-link></td>
          <td :class="`table-${c.expiration_date_class}`">{{ c.expiration_date }}</td>
          <td>
            <b-button :href="`/certificates/${c.id}.key`" variant="outline-primary">{{ ta('certificate', 'certificate_key') }}</b-button>
            <b-button :href="`/certificates/${c.id}.csr`" variant="outline-secondary" v-if="c.expiration_date === 'in progress'">{{ ta('certificate', 'certificate_request') }}</b-button>
            <label class="label btn btn-outline-secondary" v-if="c.expiration_date === 'in progress'">{{ ta('certificate', 'certificate_upload') }}
              <input type="file" @change="onFileChange(c.id, $event)" multiple="multiple" class="file" />
            </label>
            <b-button :href="`/certificates/${c.id}.cer`" variant="outline-primary" v-else>{{ ta('certificate', 'certificate')}}</b-button>
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

  </div>
</template>

<script>
import axios from 'axios'
import ModelForm from './ModelForm.vue'
import PaginateLink from './PaginateLink.vue'

export default {
  components: { ModelForm, PaginateLink },
  data() {
    return {
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
    onFileChange(certificateId, e) {
      const file = e.target.files[0]
      const reader = new FileReader()
      reader.readAsText(file)
      reader.onload = () => {
        const body = { certificate: { certificate: reader.result } }
        axios.put(`/certificates/${certificateId}.json`, body)
        .then(
          response => {
            this.updatCertificates()
            this.$toasted.show('Certificate was successfully updated.')
          }
        ).catch(
          error => {
            this.$toasted.show('Error occurred.', {type: 'error'})
          }
        )
      }
      reader.onerror = () => {
        console.log(reader.error)
      }
    },
    updatCertificates() {
      axios.get(`/hosts/${this.$route.params.id}/certificates.json`, {withCredentials: true})
        .then(response => {
          this.certificates = response.data
        })
      },
  },
  mounted() {
    this.updatCertificates()
  },
}
</script>

<style scoped>
input.file {
  display: none;
}
.label {
  margin-top: 8px;
}
</style>