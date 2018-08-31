<template>
  <div class="episode">
    <div class="image">
      <img v-if="episode.image" :src="episode.image.preview_url" />
      <div v-else class="image-placeholder" />
    </div>
    <div class="player">
      <h1>#{{episode.number | integer}}: {{episode.title}}</h1>

      <p class="published-at">
        {{episode.published_at | date}}
        <router-link :to="{name: 'episodes_show', params: {id: episode.number, slug: episode.slug}}"
                     v-if="audioProcessed">
          <permalink class="permalink-image" :size="10" />
        </router-link>
      </p>

      <p>{{episode.description}}</p>

      <episode-actions :episode="episode" />
    </div>
  </div>
</template>

<script>
  import EpisodeActions from 'components/EpisodeActions.vue'
  import Permalink from 'images/Permalink.vue'

  export default {
    props: ['episode'],
    components: {EpisodeActions, Permalink},

    computed: {
      audioProcessed() { return this.episode.audio && this.episode.audio.mp3 && this.episode.audio.aac }
    }
  }
</script>

<style scoped lang="scss">
  @import "../../../styles/vars";

  .episode {
    display: flex;
    flex-flow: row nowrap;
    align-items: flex-start;

    &:not(:last-child) {
      margin-bottom: 50px;
    }

    .image {
      flex: 0 0 auto;
      margin-right: 15px;

      img {
        width: 100px;
        height: 100px;
      }
    }

    .player {
      flex: 1 1 auto;

      h1 {
        font-size: 20px;
        line-height: 20px;
        margin: 0;
      }

      p {
        font-size: 11px;
        line-height: 15px;
      }
    }
  }

  p.published-at {
    font-family: "Libre Franklin", sans-serif;
    margin-top: 5px;
    color: $dark-gray;

    .permalink-image {
      margin-left: 3px;
    }
  }

  @include responsive-small {
    .image {
      display: none;
    }
  }

  .image-placeholder {
    background-color: $light-gray;
    width: 100px;
    height: 100px;
  }
</style>
