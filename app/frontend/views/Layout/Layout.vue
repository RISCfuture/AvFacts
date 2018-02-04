<template>
  <div>
    <banner />

    <div class="container content-view">
      <router-view />
    </div>

    <footer-view />
  </div>
</template>

<script>
  import Banner from './Banner.vue'
  import Footer from './Footer.vue'

  export default {
    components: {Banner, FooterView: Footer}
  }
</script>

<style lang="scss" scoped>
  @media only screen and (min-width: 960px) {
    header {
      position: fixed;
      left: 0;
      top: 0;
      width: 100%;
      z-index: 1;
    }

    .content-view {
      margin-top: 140px;
    }
  }
</style>
