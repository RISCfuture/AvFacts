<template>
  <div>
    <h1>Not Found</h1>
    <p class="error">You tried to go somewhere that doesn’t exist.</p>
  </div>
</template>

<script>
  export default {
  }
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  p, h1 {
    text-align: center;
  }

  @include responsive-desktop {
    div {
      padding: 40px 0;
    }
  }
</style>
