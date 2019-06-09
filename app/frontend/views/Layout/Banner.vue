<template>
  <div class="parent">
    <div class="container">
      <router-link :to="{name: 'episodes_list'}">
        <img :src="bannerImage"
             alt="AvFacts: Aviation knowledge without limits" />
      </router-link>
      <div class="spacer" />
      <p>an aviation podcast by <router-link :to="{name: 'about'}">Tim Morgan</router-link></p>
    </div>
  </div>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import BannerImage from 'images/banner-image.png'

  @Component
  export default class Banner extends Vue {
    bannerImage = BannerImage
  }
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  .parent {
    background-color: $banner-background-color;

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
