<template>
  <div v-if="!isAuthenticated">
    <error-404 />
  </div>

  <div v-else>
    <h1>Add New Episode</h1>
    <episode-form :episode="episode" />
  </div>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Getter} from 'vuex-class'

  import {ScratchEpisode} from 'types'
  import SmartFormBus from 'components/SmartForm/SmartFormBus'
  import Error404 from 'views/error/404'
  import EpisodeForm from './Form'

  @Component({
    components: {Error404, EpisodeForm}
  })
  export default class New extends Vue {
    episode: ScratchEpisode = {}

    @Getter isAuthenticated: boolean

    mounted() {
      SmartFormBus.$on('success', () => this.$router.push({name: 'episodes_list'}))
    }
  }
</script>
