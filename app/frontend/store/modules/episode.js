import Axios from 'axios'

export default {
  state: {
    episode: null,
    episodeLoading: false,
    episodeError: null
  },

  getters: {
    episode: state => state.episodeLoading ? null : state.episode,
    episodeLoading: state => state.episodeLoading,
    episodeError: state => state.episodeError
  },

  mutations: {
    START_EPISODE(state) {
      state.episodeLoading = true
    },

    SET_EPISODE(state, {episode}) {
      state.episode = episode
      state.episodeLoading = false
    },

    SET_EPISODE_ERROR(state, {error}) {
      state.episode = null
      state.episodeError = error
      state.episodeLoading = false
    }
  },

  actions: {
    loadEpisode({commit, state}, {number}) {
      if (state.episode && state.episode.number === number)
        return Promise.resolve(false)

      return new Promise(async (resolve, reject) => {
        commit('START_EPISODE')

        try {
          let {data: episode} = await Axios.get(`/episodes/${number}.json`)
          commit('SET_EPISODE', {episode})
          resolve(true)
        } catch (error) {
          commit('SET_EPISODE_ERROR', {error})
          reject(error)
        }
      })
    }
  }
}
