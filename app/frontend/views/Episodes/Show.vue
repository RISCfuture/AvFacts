<template>
  <page-loading v-if="episodeLoading" />

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

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Action, Getter} from 'vuex-class'

  import {Episode} from 'types'
  import audioProcessed from 'utilities/audioProcessed'
  import PageLoading from 'components/PageLoading.vue'
  import Error404 from 'views/error/404'
  import EpisodeActions from 'components/EpisodeActions.vue'

  @Component({
    components: {Error404, EpisodeActions, PageLoading}
  })
  export default class Show extends Vue {
    @Getter episode: Episode
    @Getter episodeLoading: boolean

    get audioProcessed(): boolean { return audioProcessed(this.episode) }

    @Action loadEpisode: (params: {number: number}) => Promise<boolean>

    private checkSlug() {
      if (!this.episode) return
      if (this.$route.params.slug !== this.episode.slug) {
        this.$router.replace({name: 'episodes_show', params: {id: this.episode.number.toString(), slug: this.episode.slug}})
      }
    }

    mounted() {
      this.loadEpisode({number: Number(this.$route.params.id)})
          .then(() => this.checkSlug())
    }
  }
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

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
