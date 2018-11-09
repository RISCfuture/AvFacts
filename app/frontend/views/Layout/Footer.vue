<template>
  <footer class="container" ref="footer">
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
  import moment from 'moment'
  import {mapGetters, mapActions} from 'vuex'

  export default {
    computed: {
      ...mapGetters(['isAuthenticated']),
      year() { return moment().format('YYYY') }
    },

    methods: {
        ...mapActions(['showLoginLightbox', 'logout']),

      recalculateContentPadding() {
        const height = this.$refs.footer.offsetHeight
        document.querySelector('body>div').style = `padding-bottom: ${height + 20}px`
      }
    },

    mounted() {
      this.recalculateContentPadding()
      window.addEventListener('resize', () => this.recalculateContentPadding())
    }
  }
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  footer {
    position: fixed;
    left: 0;
    bottom: 0;
    z-index: $footer-layer;

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
