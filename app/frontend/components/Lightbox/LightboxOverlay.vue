<template>
  <transition name="fade">
    <div class="overlay" v-if="shown">&nbsp;</div>
  </transition>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'

  import LightboxBus from './LightboxBus'

  @Component
  export default class LightboxOverlay extends Vue {
    shown = false

    created() {
      LightboxBus.$on('lightbox:updated', shown => this.shown = shown)
    }
  }
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  .overlay {
    position: fixed;
    left: 0;
    top: 0;
    z-index: $lightbox-layer - 1;

    width: 100vw;
    height: 100vh;

    background-color: rgba(0, 0, 0, 0.5);
  }
</style>
