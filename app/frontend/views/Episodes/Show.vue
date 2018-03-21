<template>
  <div v-if="episodesLoading">
    <img :src="spinnerURL" class="spinner" />
  </div>

  <div v-else-if="episode">
    <h1>#{{episode.number | integer}}: {{episode.title}}</h1>
    <p class="published-at">{{episode.published_at | date}}</p>

    <div class="summary">
      <img class="image" :src="episode.image.preview_url" />
      <p>{{episode.description}}</p>
    </div>

    <div v-if="audioProcessed && !playOpen" class="actions">
      <a href="#"
         @click.prevent="play"
         class="play-button">Play</a>
      <span class="duration">{{episode.audio.duration | duration}}</span>
    </div>

    <audio controls v-if="audioProcessed && playOpen" autoplay>
      <source :src="episode.audio.aac.url"
              :type="episode.audio.aac.content_type" />
      <source :src="episode.audio.mp3.url"
              :type="episode.audio.mp3.content_type" />
    </audio>
  </div>

  <div v-else>
    <error-404 />
  </div>
</template>

<script>
  import {mapActions, mapGetters} from 'vuex'
  import _ from 'lodash'

  import Error404 from 'views/error/404'
  import Spinner from 'images/spinner.svg'

  export default {
    data() {
      return {
        spinnerURL: Spinner,
        playOpen: false
      }
    },

    components: {Error404},

    computed: {
      ...mapGetters(['episodes', 'episodesLoading']),

      episode() {
        if (this.episodesLoading) return null
        return _.find(this.episodes, e => e.number.toString() === this.$route.params.id)
      },

      audioProcessed() { return this.episode.audio && this.episode.audio.mp3 && this.episode.audio.aac }
    },

    methods: {
      ...mapActions(['loadEpisodes']),

      play() { this.playOpen = true },
    },

    mounted() { this.loadEpisodes() }
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

  span.duration {
    font-family: "Libre Franklin", sans-serif;
    font-size: 12px;
    color: $light-gray;
    margin-left: 0.5em;
  }

  a.play-button {
    @include button($avfacts-blue);
  }

  @include responsive-small {
    .image {
      display: none;
    }
  }
</style>
