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

<script>
  import {mapActions, mapGetters} from 'vuex'

  import Error404 from 'views/error/404'
  import PageLoading from 'components/PageLoading.vue'
  import EpisodeForm from './Form'
  import SmartFormBus from 'components/SmartForm/SmartFormBus'

  export default {
    components: {Error404, EpisodeForm, PageLoading},

    computed: mapGetters(['episode', 'isAuthenticated', 'episodeLoading']),

    methods: {
      ...mapActions(['loadEpisode', 'loadSession']),

      async refresh() {
        await this.loadSession({skipIfAlreadyLoaded: true})
        this.loadEpisode({number: this.$route.params.id})
      }
    },

    mounted() {
      this.refresh()
      SmartFormBus.$on('success', () => this.refresh())
    }
  }
</script>
