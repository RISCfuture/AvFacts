<template>
  <div v-if="!isAuthenticated">
    <error-404 />
  </div>

  <div v-else-if="episodeLoading">
    <img :src="spinnerURL" class="spinner" />
  </div>

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
  import Spinner from 'images/spinner.svg'
  import EpisodeForm from './Form'
  import SmartFormBus from 'components/SmartForm/SmartFormBus'

  export default {
    data() {
      return {
        spinnerURL: Spinner
      }
    },

    components: {Error404, EpisodeForm},

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

<style scoped lang="scss">
  img.spinner {
    display: block;
    margin-left: auto;
    margin-right: auto;
  }
</style>
