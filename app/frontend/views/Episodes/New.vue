<template>
  <div v-if="!isAuthenticated">
    <error-404 />
  </div>

  <div v-else>
    <h1>Add New Episode</h1>
    <episode-form :episode="episode" />
  </div>
</template>

<script>
  import {mapGetters} from 'vuex'

  import Error404 from 'views/error/404'
  import EpisodeForm from './Form'
  import SmartFormBus from 'components/SmartForm/SmartFormBus'

  export default {
    data() {
      return {
        episode: {}
      }
    },

    components: {Error404, EpisodeForm},

    computed: {
      ...mapGetters(['isAuthenticated']),
    },

    mounted() {
      SmartFormBus.$on('success', () => this.$router.push({name: 'episodes_list'}))
    }
  }
</script>
