import axios from 'axios'
import _ from 'lodash'

export default {
  state: {
    episodes: [],
    episodesLoading: false,
    episodesError: false,
    episodesFilter: null
  },

  getters: {
    episodes: state => state.episodesLoaded ? state.episodes : [],
    episodesError: state => state.episodesError,
    episodesLoading: state => state.episodesLoading || state.episodeLoading,
    episodesLoaded: state => state.episodesLoaded,
  },

  mutations: {
    RESET_EPISODES(state) {
      state.episodes = []
      state.episodesLoading = false
      state.episodesLoaded = false
      state.episodesError = null
    },

    START_EPISODES(state) {
      state.episodesLoading = true
    },

    APPEND_EPISODES(state, {page}) {
      page.forEach(e => e.partial = true)
      state.episodes = state.episodes.concat(page)
    },

    FINISH_EPISODES(state) {
      state.episodesLoaded = true
      state.episodesLoading = false
    },

    SET_EPISODES_ERROR(state, {error}) {
      state.episodes = []
      state.episodesLoaded = true
      state.episodesLoading = false
      state.episodesError = error
    },

    SET_FILTER(state, {filter}) {
      state.episodesFilter = filter
    }
  },

  actions: {
    loadEpisodes({commit, state}, {restart} = {}) {
      if (state.episodesLoading) return Promise.resolve(false)
      if (!restart && state.episodesLoaded) return Promise.resolve(false)

      const loadNextPage = async function(url, resolve, reject) {
        try {
          let {data: page, headers} = await axios.get(url)
          commit('APPEND_EPISODES', {page})

          if (headers['x-next-page'])
            await loadNextPage(headers['x-next-page'], resolve, reject)
          else
            commit('FINISH_EPISODES')
          resolve(true)
        } catch (error) {
          commit('SET_EPISODES_ERROR', {error})
          reject(error)
        }
      }

      return new Promise((resolve, reject) => {
        commit('RESET_EPISODES')
        commit('START_EPISODES')
        return loadNextPage(`/episodes.json?filter=${state.episodesFilter || ''}`,
            resolve, reject)
      })
    },
      })
    },

    setFilter({commit}, {filter} = {}) {
      return new Promise(resolve => {
        commit('SET_FILTER', {filter})
        resolve(true)
      })
    }
  }
}
