<template>
  <header>
    <div class="container">
      <router-link :to="{name: 'episodes_list'}">
        <img :src="bannerImage"
             alt="AvFacts: Aviation knowledge without limits" />
      </router-link>
      <div class="spacer" />
      <p>an aviation podcast by <router-link :to="{name: 'about'}">Tim Morgan</router-link></p>
    </div>
  </header>
</template>

<script>
  import BannerImage from 'images/banner-image.png'

  export default {
    data() {
      return {
        bannerImage: BannerImage
      }
    },
  }
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  header {
    background-color: $banner-background-color;
    margin-bottom: 40px;
    z-index: $banner-layer;

    .container {
      display: flex;
      flex-flow: row nowrap;
      align-items: center;
      height: 100px;

      img {
        display: block;
        flex: 0 0 auto;
        width: 250px;
        height: 80px;
      }

      .spacer {
        flex: 1 1 auto;
      }

      p {
        flex: 0 0 auto;
        font-family: "Libre Franklin", sans-serif;
        color: $background-color;
        font-size: 14px;
      }

      a {
        color: $background-color;
      }
    }
  }

  @include responsive-mobile {
    header {
      margin-bottom: 0;
    }

    header p {
      display: none;
    }
  }
</style>
