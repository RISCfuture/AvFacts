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
        <router-link :to="{name: 'episodes_show', params: {id: episode.number}}" v-if="audioProcessed">
          <img :src="permalinkImage" />
        </router-link>
      </p>
      <p>{{episode.description}}</p>

      <div v-if="!playOpen" class="actions">
        <div class="left-actions">
          <a v-if="audioProcessed" href="#" @click.prevent="play" class="play-button">Play</a>
          <span v-if="audioProcessed" class="duration">{{episode.audio.duration | duration}}</span>
        </div>

        <div class="right-actions">
          <router-link :to="{name: 'episodes_script', params: {id: episode.number}}"
                       class="other-button"
                       v-if="isAuthenticated && episode['script?']">Perform</router-link>
          <router-link :to="{name: 'episodes_edit', params: {id: episode.number}}"
                       class="other-button"
                       v-if="isAuthenticated">Edit</router-link>
        </div>
      </div>

      <audio controls v-if="audioProcessed && playOpen" autoplay>
        <source :src="episode.audio.aac.url"
                :type="episode.audio.aac.content_type" />
        <source :src="episode.audio.mp3.url"
                :type="episode.audio.mp3.content_type" />
      </audio>
    </div>
  </div>
</template>

<script>
  import {mapGetters} from 'vuex'
  import PermalinkImage from 'images/permalink.svg'

  export default {
    props: ['episode'],

    data() {
      return {
        playOpen: false
      }
    },

    computed: {
      ...mapGetters(['isAuthenticated']),

      audioProcessed() { return this.episode.audio && this.episode.audio.mp3 && this.episode.audio.aac },
      permalinkImage() { return PermalinkImage }
    },

    methods: {
      play() { this.playOpen = true }
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

      audio {
        margin-top: 5px;
      }
    }
  }

  .actions {
    display: flex;
    flex-flow: row wrap;

    .left-actions { flex: 1 1 auto; }
    .right-actions {
      flex: 1 1 auto;
      text-align: right;
    }
  }

  p.published-at {
    font-family: "Libre Franklin", sans-serif;
    margin-top: 5px;
    color: $dark-gray;

    img {
      width: 10px;
      height: 10px;
      margin-left: 3px;
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

  a.other-button {
    @include button($avfacts-white, $text-dark: true);
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
