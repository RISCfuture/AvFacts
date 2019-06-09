<template>
  <div>
    <div class="title-search">
      <h1>
        All Episodes
        <router-link :to="{name: 'episodes_new'}" v-if="isAuthenticated">Upload New</router-link>
      </h1>
      <div class="spacer" />
      <input type="search" placeholder="Find an episode" v-model.trim="filter" @keyup="updateFilter" />
    </div>

    <div v-infinite-scroll="loadEpisodes" infinite-scroll-disabled="episodesLoading">
      <episode v-for="episode in episodes"
               :key="episode.number"
               :episode="episode" />

      <p class="no-episodes" v-if="episodes.length === 0">No episodes yet.</p>
    </div>

    <page-loading v-if="episodesLoading" />

    <p v-if="episodesError" class="error">Sorry, but an error occurred when
      trying to load podcast episodes. Please try again later.</p>
  </div>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Action, Getter} from 'vuex-class'

  import Episode from './Episode.vue'
  import PageLoading from 'components/PageLoading.vue'

  @Component({
    components: {Episode, PageLoading}
  })
  export default class Index extends Vue {
    filter?: string = null
    filterTimeout?: number = null

    @Getter episodes: Episode[]
    @Getter episodesLoading: boolean
    @Getter episodesError?: Error
    @Getter isAuthenticated: boolean

    @Action loadEpisodes: (params: {restart: boolean}) => Promise<boolean>
    @Action setFilter: (params: {filter?: string}) => void

    updateFilter() {
      if (this.filterTimeout) {
        window.clearTimeout(this.filterTimeout)
        this.filterTimeout = null
      }

      this.filterTimeout = window.setTimeout(async () => {
        await this.setFilter({filter: this.filter})
        this.loadEpisodes({restart: true})
      }, 250)
    }

    mounted() { this.loadEpisodes({restart: true}) }
  }
</script>

<style scoped lang="scss">
  @import "../../../styles/vars";

  .title-search {
    display: flex;
    flex-flow: row nowrap;
    align-items: baseline;

    h1 {
      flex: 0 0 auto;

      a {
        font-size: 14px;
        font-weight: normal;
        letter-spacing: -1px;
      }
    }

    .spacer {
      flex: 1 1 auto;
      min-width: 20px;
    }

    input {
      display: block;
      flex: 0 0 auto;
      width: 200px;
      text-align: right;
      border: none;
      border-right: 2px solid $placeholder-color;
      padding-right: 5px;

      &:focus {
        border-right-color: transparent;
      }
    }
  }

  @include responsive-small {
    .title-search {
      flex-flow: column nowrap;

      h1 {
        margin-bottom: 10px;
      }

      .spacer {
        display: none;
      }

      input {
        text-align: left;
        border-left: 2px solid $placeholder-color;
        border-right: none;
        padding-left: 5px;
        padding-right: 0;
        margin-bottom: 20px;
      }
    }
  }

  p.no-episodes {
    font-family: "Libre Franklin", sans-serif;
  }
</style>
