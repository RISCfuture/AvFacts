<template>
  <lightbox :shown="loginLightboxShown">
    <header>
      <h1>Log in to AvFacts</h1>
      <lightbox-close-button :onClose="hideLoginLightbox" />
    </header>

    <p class="error" v-if="sessionError">{{sessionErrorText}}</p>

    <form>
      <input type="text"
             required
             maxlength="50"
             v-model="username"
             placeholder="Username"
             v-focus="true"
             :class="fieldClass" />
      <input type="password"
             required
             v-model="password"
             placeholder="Password"
             :class="fieldClass" />
      <input type="submit"
             name="commit"
             value="Log In"
             @click.prevent="submitCredentials" />
    </form>
  </lightbox>
</template>

<script>
  import {mapActions, mapGetters} from 'vuex'
  import Lightbox from 'components/Lightbox/Lightbox'
  import LightboxCloseButton from 'components/Lightbox/LightboxCloseButton'

  export default {
    data() {
      return {
        username: null,
        password: null
      }
    },

    components: {Lightbox, LightboxCloseButton},

    computed: {
      ...mapGetters(['loginLightboxShown', 'sessionError']),

      fieldClass() { return this.sessionError ? 'invalid' : null },

      sessionErrorText() {
        if (!this.sessionError) return null;
        if (this.sessionError.response.status === 401) return "Incorrect username or password."
        else return this.sessionError;
      }
    },

    methods: {
      ...mapActions(['hideLoginLightbox', 'login', 'resetSessionError', 'loadEpisodes']),

      submitCredentials() {
        this.login({username: this.username, password: this.password})
            .then(() => {
              this.hideLoginLightbox()
              this.loadEpisodes({restart: true})
            })
      }
    },

    watch: {
      loginLightboxShown(newShown, oldShown) {
        if (newShown && !oldShown) {
          this.username = null
          this.password = null
          this.resetSessionError()
        }
      }
    }
  }
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  header {
    display: flex;
    flex-flow: row nowrap;
    align-items: flex-start;
  }

  h1 {
    flex: 1 1 auto;
    margin: -5px 0 20px;
    font-size: 14px;
    color: $dark-gray;
    font-weight: 500;
  }

  a {
    display: block;
    flex: 0 0 auto;
    margin: -10px -10px 0 0;
  }

  p.error {
    margin-top: 0;
    font-weight: normal;
  }
</style>
