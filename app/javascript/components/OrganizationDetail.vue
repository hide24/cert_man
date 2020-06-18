<template>
  <dl>
    <dt>ID</dt>
    <dd>{{ organization.id }}</dd>
    <dt>Name</dt>
    <dd>{{ organization.name }}</dd>
    <dt>Country</dt>
    <dd>{{ organization.country }}</dd>
    <dt>State</dt>
    <dd>{{ organization.state }}</dd>
    <dt>Locality</dt>
    <dd>{{ organization.locality }}</dd>
    <dt>Organization</dt>
    <dd>{{ organization.organization }}</dd>
    <dt>Organizational Unit</dt>
    <dd>{{ organization.unit }}</dd>
    <dt>Mail</dt>
    <dd>{{ organization.mail }}</dd>
  </dl>
</template>

<script>
export default {
  props: ["organization"],
}
</script>

<style scoped>
</style>