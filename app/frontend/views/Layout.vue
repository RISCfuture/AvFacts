<template>
  <div>
    <router-view />
    <lightbox-overlay />
    <login-lightbox />
  </div>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Action} from 'vuex-class'

  import LoginLightbox from 'views/Layout/LoginLightbox'
  import LightboxOverlay from 'components/Lightbox/LightboxOverlay'

  @Component({
    components: {LightboxOverlay, LoginLightbox}
  })
  export default class Layout extends Vue {
    @Action loadSession: (params: {skipIfAlreadyLoaded: boolean}) => Promise<boolean>

    mounted() { this.loadSession({skipIfAlreadyLoaded: false}) }
  }
</script>
