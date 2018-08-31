<template>
  <div v-if="playOpen">
    <audio controls v-if="audioProcessed">
      <source :src="episode.audio.aac.url"
              :type="episode.audio.aac.content_type" />
      <source :src="episode.audio.mp3.url"
              :type="episode.audio.mp3.content_type" />
    </audio>
  </div>

  <div v-else class="actions">
    <div class="left-actions">
      <a v-if="audioProcessed" href="#" @click.prevent="play" class="play-button">
        <play :height="16" />
      </a>
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
</template>

<script>
  import {mapGetters} from 'vuex'
  import Play from 'images/Play.vue'

  export default {
    props: ['episode'],

    data() {
      return {
        playOpen: false
      }
    },

    components: {Play},

    computed: {
      ...mapGetters(['isAuthenticated']),
      audioProcessed() { return this.episode.audio && this.episode.audio.mp3 && this.episode.audio.aac },
    },

    methods: {
      play() { this.playOpen = true }
    }
  }
</script>

<style scoped lang="scss">
  @import "../styles/vars";

  .actions {
    display: flex;
    flex-flow: row wrap;

    .left-actions { flex: 1 1 auto; }
    .right-actions {
      flex: 1 1 auto;
      text-align: right;
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
    display: inline-block;
    vertical-align: middle;
    box-sizing: border-box;
    width: 20px;
    height: 24px;
    padding: 4px 0;

    @include responsive-desktop { min-width: 30px; }
  }

  a.other-button {
    @include button($avfacts-white, $text-dark: true);
  }
</style>
