<template>
  <a href="#" @click.prevent="onClose" @mousedown="closeActive = true" @mouseup="closeActive = false">
    <close-button :active="closeActive" />
  </a>
</template>

<script>
  import CloseButton from 'images/CloseButton'

  export default {
    props: {onClose: Function},

    components: {CloseButton},

    data() {
      return {closeActive: false}
    }
  }
</script>

<style scoped>

</style>
