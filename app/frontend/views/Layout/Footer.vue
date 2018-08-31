<template>
  <footer class="container">
    <p class="copyright">
      AvFacts and this website are copyright ©2017–{{year}} Tim Morgan. All
      rights reserved.
    </p>
    <p class="login">
      <a href="#" @click.prevent="showLoginLightbox" v-if="!isAuthenticated">Log in</a>
      <a href="#" @click.prevent="logout" v-if="isAuthenticated">Log out</a>
    </p>
  </footer>
</template>

<script>
  import {mapGetters, mapActions} from 'vuex'

  export default {
    computed: {
      ...mapGetters(['isAuthenticated']),
      year() { return new Date().getFullYear() }
    },

    methods: mapActions(['showLoginLightbox', 'logout'])
  }
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  footer {
    position: fixed;
    left: 0;
    bottom: 0;
    z-index: 100;

    padding: 5px 20px;
    width: 100%;
    box-sizing: border-box;

    background-color: white;

    display: flex;
    flex-flow: row nowrap;
    align-items: flex-start;

    .copyright {
      flex: 1 1 auto;
    }

    .login {
      flex: 0 0 auto;
    }
  }

  p {
    font-size: 12px;
  }

  @include responsive-mobile {
    footer {
      flex-flow: column nowrap;
    }
  }
</style>
