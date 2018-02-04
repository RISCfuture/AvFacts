<template>
  <div v-if="!isAuthenticated">
    <error-404 />
  </div>

  <div v-else-if="episodesLoading">
    <img :src="spinnerURL" class="spinner" />
  </div>

  <div v-else-if="episode" class="container">
    <h1>#{{episode.number | integer}}: {{episode.title}}</h1>
    <div class="script" v-html="renderedScript" />
  </div>

  <div v-else>
    <error-404 />
  </div>
</template>

<script>
  import marked from 'marked'
  import {mapActions, mapGetters} from 'vuex'

  import Error404 from 'views/error/404'
  import Spinner from 'images/spinner.svg'

  marked.setOptions({
    gfm: true,
    tables: true,
    breaks: false,
    pedantic: false,
    sanitize: true,
    smartLists: true,
    smartypants: true
  })

  export default {
    components: {Error404},

    data() {
      return {
        spinnerURL: Spinner
      }
    },

    computed: {
      ...mapGetters(['episode', 'isAuthenticated', 'episodesLoading']),

      renderedScript() { return marked(this.episode.script) }
    },

    methods: {
      ...mapActions(['loadEpisode', 'loadSession']),

      refresh() {
        this.loadSession({skipIfAlreadyLoaded: true}).then(() => {
          this.loadEpisode(this.$route.params.id, {restart: true})
        })
      }
    },

    mounted() {
      this.refresh()
    }
  }
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  @include responsive-desktop {
    .container {
      width: 540px;
      margin-left: auto;
      margin-right: auto;
    }
  }

  .script {
    margin-bottom: 100vh;
  }

  .script, .script p {
    font-size: 24px;
    line-height: 32px;
  }

  img.spinner {
    display: block;
    margin-left: auto;
    margin-right: auto;
  }
</style>
