<template>
  <page-loading v-if="episodeLoading" />

  <div v-else-if="!isAuthenticated">
    <error-404 />
  </div>

  <div v-else-if="episode" class="container">
    <h1>
      #{{episode.number | integer}}: {{episode.title}}
      <router-link :to="{name: 'episodes_edit', params: {id: episode.number}}">
        Back to Edit
      </router-link>
    </h1>

    <template v-if="episode.script">
      <p id="running-time">Estimated running time: {{estimatedRunningTime | duration}}</p>
      <div class="script" v-html="renderedScript" />
    </template>
    <div class="script" v-else>
      <p><em>This episode does not have a script.</em></p>
    </div>
  </div>

  <div v-else>
    <error-404 />
  </div>
</template>

<script lang="ts">
  import * as marked from 'marked'

  import Error404 from 'views/error/404'
  import PageLoading from 'components/PageLoading.vue'
  import Vue from 'vue';
  import Component from "vue-class-component";
  import {Action, Getter} from "vuex-class";
  import {Episode} from "types";

  marked.setOptions({
    gfm: true,
    tables: true,
    breaks: false,
    pedantic: false,
    sanitize: true,
    smartLists: true,
    smartypants: true
  })

  @Component({
    components: {Error404, PageLoading}
  })
  export default class Script extends Vue {
    @Getter episode: Episode
    @Getter isAuthenticated: boolean
    @Getter episodeLoading: boolean

    get renderedScript(): string { return marked(this.episode.script) }

    get estimatedRunningTime(): number {
      const wordCount = this.episode.script.split(/\s+/).length
      return Math.round(0.3472*wordCount + 69.6)
    }

    @Action loadEpisode: (params: {number: number}) => Promise<boolean>
    @Action loadSession: (params: {skipIfAlreadyLoaded: boolean}) => Promise<boolean>

    private async refresh() {
      await this.loadSession({skipIfAlreadyLoaded: true})
      this.loadEpisode({number: Number(this.$route.params.id)})
    }

    mounted() {
      this.refresh()
    }
  }
</script>

<style scoped lang="scss">
  @import "../../styles/vars";

  h1 a {
    font-size: 14px;
    font-weight: normal;
    letter-spacing: -1px;
  }

  @include responsive-desktop {
    .container {
      width: 540px;
      margin-left: auto;
      margin-right: auto;
    }
  }

  #running-time {
    color: $light-gray;
    font-size: 12px;
  }

  .script {
    margin-bottom: 100vh;
  }

  .script, .script p {
    font-size: 24px;
    line-height: 32px;
  }
</style>
