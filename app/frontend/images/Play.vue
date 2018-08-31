<template>
  <svg :width="width" :height="height" viewBox="0 0 26 28" xmlns="http://www.w3.org/2000/svg">
    <path d="M24.1 12.27L3.9.61a2 2 0 0 0-3 1.73v23.32a2 2 0 0 0 3 1.73l20.2-11.66a2 2 0 0 0 0-3.46z"
          :fill="fill" fill-rule="nonzero" />
  </svg>
</template>

<script>
  export default {
    props: {
      fill: {type: String, default: '#fff'},
      height: {type: Number, default: 28}
    },

    computed: {
      width() { return (this.height/28) * 26 }
    }
  }
</script>

