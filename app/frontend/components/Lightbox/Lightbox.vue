<template>
  <transition name="fade">
    <div class="lightbox"
         v-if="shown"
         ref="lightbox"
         :style="style"> <!-- TODO unsafe inline -->
      <slot />
    </div>
  </transition>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Prop} from 'vue-property-decorator'

  import LightboxBus from './LightboxBus'

  @Component
  export default class Lightbox extends Vue {
    @Prop({type: Boolean}) shown: boolean

    $refs!: {
      lightbox: HTMLElement
    }

    width: number
    height: number

    get style(): string {
      return `transform: translate(-${this.width/2.0}px, -${this.height/2.0}px)`
    }

    private resize() {
      if (!this.$refs.lightbox) return
      this.width = this.$refs.lightbox.offsetWidth
      this.height = this.$refs.lightbox.offsetHeight
    }

    mounted() { this.resize() }

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
