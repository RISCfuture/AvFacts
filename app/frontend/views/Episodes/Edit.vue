<template>
  <div v-if="!isAuthenticated">
    <error-404 />
  </div>

  <page-loading v-else-if="episodeLoading" />

  <div v-else-if="episode">
    <h1>#{{episode.number | integer}}: {{episode.title}}</h1>
    <episode-form :episode="episode" />
  </div>

  <div v-else>
    <error-404 />
  </div>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Action, Getter} from 'vuex-class'

  import {Episode} from 'types'
  import Error404 from 'views/error/404'
  import PageLoading from 'components/PageLoading.vue'
  import EpisodeForm from './Form'
  import SmartFormBus from 'components/SmartForm/SmartFormBus'

  @Component({
    components: {Error404, EpisodeForm, PageLoading}
  })
  export default class Edit extends Vue {
    @Getter episode?: Episode
    @Getter isAuthenticated: boolean
    @Getter episodeLoading: boolean

    @Action loadEpisode: (params: {number: number}) => Promise<boolean>
    @Action loadSession: (params: {skipIfAlreadyLoaded: boolean}) => Promise<boolean>

    private async refresh() {
      await this.loadSession({skipIfAlreadyLoaded: true})
      this.loadEpisode({number: Number(this.$route.params.id)})
    }

    mounted() {
      this.refresh()
      SmartFormBus.$on('success', () => this.refresh())
    }
  }
</script>
