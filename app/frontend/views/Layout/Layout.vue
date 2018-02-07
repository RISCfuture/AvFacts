<template>
  <div>
    <header>
      <banner />
      <links />
    </header>

    <div class="container content-view">
      <router-view />
    </div>

    <footer-view />
  </div>
</template>

<script>
  import Banner from './Banner.vue'
  import Links from './Links.vue'
  import Footer from './Footer.vue'

  export default {
    components: {Links, Banner, FooterView: Footer}
  }
</script>

<style lang="scss" scoped>
  @import "../../styles/vars";

  @include responsive-desktop {
    header {
      position: fixed;
      left: 0;
      top: 0;
      width: 100%;
      z-index: $banner-layer;
    }

    .content-view {
      margin-top: 180px;
    }
  }

  @include responsive-mobile {
    header {
      margin-bottom: 40px;
    }

    header p {
      display: none;
    }
  }
</style>
