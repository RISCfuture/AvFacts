<template>
  <transition name="fade">
    <div class="overlay" v-if="shown">&nbsp;</div>
  </transition>
</template>

<script>
  import LightboxBus from './LightboxBus'

  export default {
    data() {
      return {shown: false}
    },

    created() {
      LightboxBus.$on('lightbox:updated', shown => this.shown = shown)
    }
  }
</script>

<style scoped lang="scss">
  .overlay {
    position: fixed;
    left: 0;
    top: 0;
    width: 100vw;
    height: 100vh;
    background-color: rgba(0, 0, 0, 0.5);
  }
</style>
