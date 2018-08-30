import Axios from 'axios'
import _ from 'lodash'

export default {
  state: {
    episodes: [],
    episodesLoading: false,
    episodesError: null,
    episodesFilter: null,
    nextURL: `/episodes.json`
  },

  getters: {
    episodes: state => state.episodesLoading ? [] : state.episodes,
    episodesError: state => state.episodesError,
    episodesLoading: state => state.episodesLoading || state.episodeLoading
  },

  mutations: {
    RESET_EPISODES(state) {
      state.episodes = []
      state.episodesLoading = false
      state.episodesError = null
      state.nextURL = `/episodes.json?filter=${state.episodesFilter || ''}`
    },

    START_EPISODES(state) {
      state.episodesLoading = true
    },

    APPEND_EPISODES(state, {page}) {
      page.forEach(e => e.partial = true)
      state.episodes = state.episodes.concat(page)
    },

    FINISH_EPISODES(state) {
      state.episodesLoading = false
    },

    SET_EPISODES_ERROR(state, {error}) {
      state.episodes = []
      state.episodesLoading = false
      state.episodesError = error
      state.nextURL = `/episodes.json?filter=${state.episodesFilter || ''}`
    },

    SET_FILTER(state, {filter}) {
      state.episodesFilter = filter
      state.nextURL = `/episodes.json?filter=${state.episodesFilter || ''}`
    },

    SET_NEXT_PAGE_URL(state, {url}) {
      state.nextURL = url
    }
  },

  actions: {
    loadEpisodes({commit, state}, {restart} = {}) {
      return new Promise(async (resolve, reject) => {
        if (restart) commit('RESET_EPISODES')
        if (!state.nextURL) return resolve(false)

        if (_.isEmpty(state.episodes)) commit('START_EPISODES')

        try {
          let {data: page, headers} = await Axios.get(state.nextURL)
          commit('APPEND_EPISODES', {page})
          commit('SET_NEXT_PAGE_URL', {url: headers['x-next-page']})
          commit('FINISH_EPISODES')
          resolve(true)
        } catch (error) {
          commit('SET_EPISODES_ERROR', {error})
          reject(error)
        }
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
