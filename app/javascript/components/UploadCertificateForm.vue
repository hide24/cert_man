<template>
  <div class="contents">
    <div class="drop_area" :class="{enter: isEnter}"
      @dragenter="dragEnter" @dragleave="dragLeave" @dragover.prevent @drop.prevent="dropFile">
      File Upload
    </div>

    <label class="input-item label">Select File
      <input type="file" @change="onFileChange" multiple="multiple" />
    </label>
    <div class="preview-item">

      <table class="table table-striped table-bordered" v-if="uploadedItems.length">
        <tbody>
          <tr>
            <th>Filename</th>
            <th>Hostname</th>
            <th>Subject</th>
            <th>Expiration Date</th>
            <th>&nbsp;</th>
          </tr>
          <tr v-for="item in uploadedItems">
            <td>{{ item.filename }}</td>
            <td v-if="item.errors" colspan="3">{{ item.errors[0] }}</td>
            <td v-if="!item.errors">{{ item.subject }}</td>
            <td v-if="!item.errors">{{ item.hostname }}</td>
            <td v-if="!item.errors">{{ item.expiration_date }}
              <p v-for="err in item.errros">{{ err }}</p>
            </td>
            <td>
              <b-button @click="confirmApply(item)" v-if="!item.errors" variant="outline-primary">Apply</b-button>
              <b-button @click="confirmDelete(item)" variant="outline-danger">Delete</b-button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  module: { axios },
  props: [ "id" ],
  data() {
    return {
      uploadedItems: [],
      isEnter: false,
      files: [],
    }
  },
  methods: {
    dragEnter() {
      this.isEnter = true
    },
    dragLeave() {
      this.isEnter = false
    },
    dropFile() {
      this.isEnter = false
      const files = [...event.dataTransfer.files]
      this.uploadFiles(files)
    },
    onFileChange(e) {
      e.preventDefault()
      const files = [...(e.target.files || e.dataTransfer.files)]
      const formData = new FormData()
      const config = {
        headers: {
          'content-type': 'multipart/form-data'
        }
      }
      this.uploadFiles(files)
    },
    uploadFiles(files) {
      const formData = new FormData()
      const config = {
        headers: {
          'content-type': 'multipart/form-data'
        }
      }
      files.forEach(file => formData.append('certificate_application[file][]', file))
      axios.post(`/certificate_applications/${this.id}/upload.json`, formData, config)
      .then(
        response => {
          this.updateItems(response.data)
        }
      )
    },
    updateItems(items) {
      items.forEach(item => {
        this.uploadedItems = this.uploadedItems.filter(i => !(i.filename === item.filename))
        this.uploadedItems.push(item)
      })
    },
    confirmApply(item) {
      axios.put(`/certificates/${item.certificate_id}.json`, { certificate: item.certificate })
      .then(
        response => {
          this.uploadedItems = this.uploadedItems.filter(i => !(i.filename === item.filename))
          this.$emit("uploaded", item)
        }
      )
    },
    confirmDelete(item) {
      this.uploadedItems = this.uploadedItems.filter(i => !(i.filename === item.filename))
    },
  },
}
</script>

<style>
label > input {
  display: none;
}

label {
  padding: 0 1rem;
  border: solid 1px #888;
} 

label::after {
  content: '+';
  font-size: 1rem;
  color: #888;
  padding-left: 1rem;
}

.drop_area {
    color: gray;
    font-weight: bold;
    font-size: 1.2em;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 500px;
    height: 300px;
    border: 5px solid gray;
    border-radius: 15px;
}

.enter {
    border: 10px dotted powderblue;
}
</style>
