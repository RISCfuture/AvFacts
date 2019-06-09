<template>
  <div class="spinner-container">
    <svg class="lds-spinner"
         xmlns="http://www.w3.org/2000/svg"
         width="200px"
         height="200px"
         viewBox="0 0 100 100"
         preserveAspectRatio="xMidYMid">
      <rect x="48" y="19" rx="2.88" ry="1.14" width="4" height="12"
            fill="#1d1d3c">
        <animate attributeName="opacity" values="1;0" dur="1s"
                 begin="-0.9166666666666666s" repeatCount="indefinite" />
      </rect>
      <rect x="48"
            y="19"
            rx="2.88"
            ry="1.14"
            width="4"
            height="12"
            fill="#1d1d3c"
            transform="rotate(30 50 50)">
        <animate attributeName="opacity" values="1;0" dur="1s"
                 begin="-0.8333333333333334s" repeatCount="indefinite" />
      </rect>
      <rect x="48"
            y="19"
            rx="2.88"
            ry="1.14"
            width="4"
            height="12"
            fill="#1d1d3c"
            transform="rotate(60 50 50)">
        <animate attributeName="opacity" values="1;0" dur="1s" begin="-0.75s"
                 repeatCount="indefinite" />
      </rect>
      <rect x="48"
            y="19"
            rx="2.88"
            ry="1.14"
            width="4"
            height="12"
            fill="#1d1d3c"
            transform="rotate(90 50 50)">
        <animate attributeName="opacity" values="1;0" dur="1s"
                 begin="-0.6666666666666666s" repeatCount="indefinite" />
      </rect>
      <rect x="48"
            y="19"
            rx="2.88"
            ry="1.14"
            width="4"
            height="12"
            fill="#1d1d3c"
            transform="rotate(120 50 50)">
        <animate attributeName="opacity" values="1;0" dur="1s"
                 begin="-0.5833333333333334s" repeatCount="indefinite" />
      </rect>
      <rect x="48"
            y="19"
            rx="2.88"
            ry="1.14"
            width="4"
            height="12"
            fill="#1d1d3c"
            transform="rotate(150 50 50)">
        <animate attributeName="opacity" values="1;0" dur="1s" begin="-0.5s"
                 repeatCount="indefinite" />
      </rect>
      <rect x="48"
            y="19"
            rx="2.88"
            ry="1.14"
            width="4"
            height="12"
            fill="#1d1d3c"
            transform="rotate(180 50 50)">
        <animate attributeName="opacity" values="1;0" dur="1s"
                 begin="-0.4166666666666667s" repeatCount="indefinite" />
      </rect>
      <rect x="48"
            y="19"
            rx="2.88"
            ry="1.14"
            width="4"
            height="12"
            fill="#1d1d3c"
            transform="rotate(210 50 50)">
        <animate attributeName="opacity" values="1;0" dur="1s"
                 begin="-0.3333333333333333s" repeatCount="indefinite" />
      </rect>
      <rect x="48"
            y="19"
            rx="2.88"
            ry="1.14"
            width="4"
            height="12"
            fill="#1d1d3c"
            transform="rotate(240 50 50)">
        <animate attributeName="opacity" values="1;0" dur="1s" begin="-0.25s"
                 repeatCount="indefinite" />
      </rect>
      <rect x="48"
            y="19"
            rx="2.88"
            ry="1.14"
            width="4"
            height="12"
            fill="#1d1d3c"
            transform="rotate(270 50 50)">
        <animate attributeName="opacity" values="1;0" dur="1s"
                 begin="-0.16666666666666666s" repeatCount="indefinite" />
      </rect>
      <rect x="48"
            y="19"
            rx="2.88"
            ry="1.14"
            width="4"
            height="12"
            fill="#1d1d3c"
            transform="rotate(300 50 50)">
        <animate attributeName="opacity" values="1;0" dur="1s"
                 begin="-0.08333333333333333s" repeatCount="indefinite" />
      </rect>
      <rect x="48"
            y="19"
            rx="2.88"
            ry="1.14"
            width="4"
            height="12"
            fill="#1d1d3c"
            transform="rotate(330 50 50)">
        <animate attributeName="opacity" values="1;0" dur="1s" begin="0s"
                 repeatCount="indefinite" />
      </rect>
    </svg>
  </div>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'

  @Component
  export default class PageLoading extends Vue {}
</script>

<style scoped lang="scss">
  @import "../styles/vars";

  .spinner-container {
    position: fixed;
    left: 0;
    top: 0;
    z-index: $banner-layer - 1;

    width: 100vw;
    height: 100vh;
    box-sizing: border-box;

    background-color: rgba(255, 255, 255, 0.8);

    display: flex;
    flex-flow: row nowrap;
    align-items: center;
    justify-content: center;
  }

  svg {
    background: none initial initial initial initial;
  }
</style>
