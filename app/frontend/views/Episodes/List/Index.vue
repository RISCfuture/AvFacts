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

    <template v-if="episodesLoaded">
      <episode v-for="episode in episodes"
               :key="episode.number"
               :episode="episode" />

      <p class="no-episodes" v-if="episodes.length === 0">No episodes yet.</p>
    </template>

    <img :src="spinnerURL" v-if="episodesLoading" class="spinner" />

    <p v-if="episodesError" class="error">Sorry, but an error occurred when
      trying to load podcast episodes. Please try again later.</p>
  </div>
</template>

<script>
  import {mapActions, mapGetters} from 'vuex'

  import Episode from './Episode.vue'
  import Spinner from 'images/spinner.svg'

  export default {
    data() {
      return {
        filter: null,
        filterTimeout: null,
        spinnerURL: Spinner
      }
    },

    components: {Episode},

    computed: mapGetters(['episodes', 'episodesLoading', 'episodesLoaded', 'episodesError', 'isAuthenticated']),

    methods: {
        ...mapActions(['loadEpisodes', 'setFilter']),
      updateFilter() {
        if (this.filterTimeout) clearTimeout(this.filterTimeout)
        this.filterTimeout = setTimeout(async () => {
          await this.setFilter({filter: this.filter})
          this.loadEpisodes({restart: true})
        }, 250)
      }
    },

    mounted() { this.loadEpisodes() }
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

  img.spinner {
    display: block;
    margin-left: auto;
    margin-right: auto;
  }

  p.no-episodes {
    font-family: "Libre Franklin", sans-serif;
  }
</style>
