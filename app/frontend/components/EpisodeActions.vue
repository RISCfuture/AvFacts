<template>
  <div v-if="playOpen" data-cy="player">
    <audio controls v-if="audioProcessed">
      <source :src="episode.audio.aac.url"
              :type="episode.audio.aac.content_type" />
      <source :src="episode.audio.mp3.url"
              :type="episode.audio.mp3.content_type" />
    </audio>
  </div>

  <div v-else class="actions">
    <div class="left-actions">
      <a v-if="audioProcessed"
         href="#"
         @click.prevent="play"
         class="play-button"
         data-cy="playButton">
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

<script lang="ts">
  import Vue from 'vue'
  import {Prop} from 'vue-property-decorator'
  import Component from 'vue-class-component'
  import {Getter} from 'vuex-class'

  import audioProcessed from 'utilities/audioProcessed'
  import {Episode} from 'types'
  import Play from 'images/Play.vue'

  @Component({
    components: {Play}
  })
  export default class EpisodeActions extends Vue {
    @Prop({required: true}) episode: Episode

    playOpen = false

    @Getter isAuthenticated: boolean

    get audioProcessed(): boolean { return audioProcessed(this.episode) }

    play() { this.playOpen = true }
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
    width: 30px;
    height: 24px;
    padding: 4px 0;
    @include responsive-desktop { min-width: 30px; }
  }

  a.other-button {
    @include button($avfacts-white, $text-dark: true);
  }
</style>
