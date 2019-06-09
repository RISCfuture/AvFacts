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
             autocomplete="username"
             :class="fieldClass" />
      <input type="password"
             required
             v-model="password"
             placeholder="Password"
             autocomplete="current-password"
             :class="fieldClass" />
      <input type="submit"
             name="commit"
             value="Log In"
             @click.prevent="submitCredentials" />
    </form>
  </lightbox>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Watch} from 'vue-property-decorator'
  import {Action, Getter} from 'vuex-class'
  import {AxiosError} from 'axios'

  import Lightbox from 'components/Lightbox/Lightbox'
  import LightboxCloseButton from 'components/Lightbox/LightboxCloseButton'

  @Component({
    components: {Lightbox, LightboxCloseButton}
  })
  export default class LoginLightbox extends Vue {
    username?: string = null
    password?: string = null

    @Getter loginLightboxShown: boolean
    @Getter sessionError?: AxiosError

    get fieldClass(): string | null { return this.sessionError ? 'invalid' : null }

    get sessionErrorText(): string | null {
      if (!this.sessionError) return null
      if (this.sessionError.response.status === 401) return "Incorrect username or password."
      else return this.sessionError.message
    }

    @Action hideLoginLightbox: () => void
    @Action login: (fields: {[name: string]: string}) => Promise<boolean>
    @Action resetSessionError: () => void
    @Action loadEpisodes: (params: {restart: boolean}) => Promise<boolean>

    async submitCredentials() {
      await this.login({username: this.username, password: this.password})
      this.hideLoginLightbox()
      this.loadEpisodes({restart: true})
    }

    @Watch('loginLightboxShown')
    onLoginLightboxShownChanged(newShown: boolean, oldShown: boolean) {
      if (newShown && !oldShown) {
        this.username = null
        this.password = null
        this.resetSessionError()
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
