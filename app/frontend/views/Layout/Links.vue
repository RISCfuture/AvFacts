<template>
  <div>
    <ul class="container">
      <li>
        <a href="https://soundcloud.com/user-155015009">SoundCloud</a>
      </li>
      <li>
        <a href="https://itunes.apple.com/us/podcast/avfacts-aviation-knowledge-without-limits/id1271248926">iTunes</a>
      </li>
      <li>
        <a href="http://stitcher.com/s?fid=169506&refid=stpr">Stitcher</a>
      </li>
      <li>
        <a href="/episodes.rss">RSS</a>
      </li>
    </ul>
  </div>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'

  @Component
  export default class Links extends Vue {}
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  div {
    background-color: darken($banner-background-color, 5%);
  }

  ul {
    margin: 0 auto;
    padding: 10px 0;
    display: flex;
    flex-flow: row nowrap;
    justify-content: center;
  }

  li {
    flex: 0 0 auto;
    font-family: "Libre Franklin", sans-serif;
    color: $background-color;
    font-size: 14px;
    padding: 0;
    margin: 0;
    list-style: none;

    &:not(:last-child)::after {
      content: "·";
      padding: 0 1em;
    }
  }

  a, a:hover, a:active, a:visited {
    color: $background-color;
  }
</style>
