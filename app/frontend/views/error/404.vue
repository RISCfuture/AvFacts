<template>
  <div>
    <h1>Not Found</h1>
    <p class="error">You tried to go somewhere that doesn’t exist.</p>
  </div>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'

  @Component
  export default class FourOhFour extends Vue {}
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  p, h1 {
    text-align: center;
  }

  @include responsive-desktop {
    div {
      padding: 40px 0;
    }
  }
</style>
