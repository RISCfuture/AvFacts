<template>
  <div>
    <router-view />
    <lightbox-overlay />
    <login-lightbox />
  </div>
</template>

<script>
  import {mapActions} from 'vuex'

  import LoginLightbox from 'views/Layout/LoginLightbox'
  import LightboxOverlay from 'components/Lightbox/LightboxOverlay'

  export default {
    components: {LightboxOverlay, LoginLightbox},
    methods: mapActions(['loadSession']),
    mounted() { this.loadSession() }
  }
</script>
