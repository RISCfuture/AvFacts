<template>
  <div v-if="episodeLoading">
    <img :src="spinnerURL" class="spinner" />
  </div>

  <div v-else-if="episode">
    <div v-if="audioProcessed">
      <h1>#{{episode.number | integer}}: {{episode.title}}</h1>
      <p class="published-at">{{episode.published_at | date}}</p>

      <div class="summary">
        <img class="image" :src="episode.image.preview_url" />
        <p>{{episode.description}}</p>
      </div>

      <episode-actions :episode="episode" />

      <p id="credits" v-if="episode.credits">{{episode.credits}}</p>
    </div>

    <div v-else>
      <h1>Not Yet Released</h1>
      <p class="error">This episode hasn’t been released yet.</p>
    </div>
  </div>

  <div v-else>
    <error-404 />
  </div>
</template>

<script>
  import {mapActions, mapGetters} from 'vuex'

  import Spinner from 'images/spinner.svg'
  import Error404 from 'views/error/404'
  import EpisodeActions from 'components/EpisodeActions.vue'

  export default {
    data() {
      return {
        spinnerURL: Spinner,
        playOpen: false
      }
    },

    components: {Error404, EpisodeActions},

    computed: {
      ...mapGetters(['episode', 'episodeLoading']),

      audioProcessed() { return this.episode.audio && this.episode.audio.mp3 && this.episode.audio.aac }
    },

    methods: {
      ...mapActions(['loadEpisode']),

      checkSlug() {
        if (!this.episode) return
        if (this.$route.params.slug !== this.episode.slug) {
          this.$router.replace({name: 'episodes_show', params: {id: this.episode.number, slug: this.episode.slug}})
        }
      },

      play() { this.playOpen = true },
    },

    mounted() {
      this.loadEpisode({number: this.$route.params.id})
          .then(() => this.checkSlug())
    }
  }
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  img.spinner {
    display: block;
    margin-left: auto;
    margin-right: auto;
  }

  h1 {
    margin-bottom: 0;
  }

  p.published-at {
    font-family: "Libre Franklin", sans-serif;
    margin-top: 5px;
    margin-bottom: 40px;
    color: $dark-gray;
    font-size: 12px;
  }

  .summary {
    display: flex;
    flex-flow: row nowrap;
    align-items: flex-start;
    margin-bottom: 40px;

    img {
      display: block;
      flex: 0 0 auto;
      margin-right: 15px;
      width: 100px;
      height: 100px;
    }

    p {
      flex: 1 1 auto;
      margin: 0;
    }
  }

  #credits {
    margin-top: 20px;
    white-space: pre-wrap;
    font-size: 12px;
  }

  @include responsive-small {
    .image {
      display: none;
    }
  }
</style>
