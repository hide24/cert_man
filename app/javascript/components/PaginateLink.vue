<template>
  <div>
    <paginate
    v-model="currentPage"
    :page-count="pageCount"
    :page-range="3"
    :margin-pages="2"
    :click-handler="changePage"
    :prev-text="'&laquo;'"
    :next-text="'&raquo;'"
    :container-class="'pagination'"
    :page-class="'page-item'"
    :page-link-class="'page-link'"
    :prev-link-class="'page-link'"
    :next-link-class="'page-link'"
    ></paginate>
  </div>
</template>

<script>
import Paginate from 'vuejs-paginate'

export default {
  components: {
    Paginate
  },
  props: ["currentPage", "pageCount"],
  methods: {
    changePage(pageNum) {
      this.$emit("changePage", pageNum)
    },
  },
}
</script>

<style scoped>
</style>