<template>
  <transition name="fade">
    <div class="lightbox"
         v-if="shown"
         ref="lightbox"
         :style="style">
      <slot />
    </div>
  </transition>
</template>

<script>
  import LightboxBus from './LightboxBus'

  export default {
    props: {shown: Boolean},

    data() {
      return {
        width: null,
        height: null
      }
    },

    computed: {
      style() {
        return `transform: translate(-${this.width/2.0}px, -${this.height/2.0}px)`
      }
    },

    methods: {
      resize() {
        if (!this.$refs.lightbox) return
        this.width = this.$refs.lightbox.offsetWidth
        this.height = this.$refs.lightbox.offsetHeight
      }
    },

    mounted() { this.resize() },
    updated() {
      this.resize()
      LightboxBus.$emit('lightbox:updated', this.shown)
    }
  }
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  .lightbox {
    position: fixed;
    left: 50%;
    top: 50%;
    z-index: $lightbox-layer;

    display: table;
    border-radius: 10px;
    box-shadow: 1px 1px 15px 0 rgba(0, 0, 0, 0.5);
    background-color: $background-color;

    padding: 20px;
    box-sizing: border-box;
  }
</style>
