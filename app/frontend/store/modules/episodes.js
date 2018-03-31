import axios from 'axios'
import _ from 'lodash'

export default {
  state: {
    episodes: [],
    episode: null,
    episodesLoading: false,
    episodeLoading: false,
    episodesLoaded: false,
    episodesError: false,
    episodesFilter: null
  },

  getters: {
    episodes: state => state.episodesLoaded ? state.episodes : [],
    episode: state => state.episode,
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

    START_EPISODE(state) {
      state.episodeLoading = true
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
    },

    SET_EPISODE(state, {episode}) {
      state.episode = episode
      state.episodeLoading = false
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
            loadNextPage(headers['x-next-page'], resolve, reject)
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
        loadNextPage(`/episodes.json?filter=${state.episodesFilter || ''}`,
            resolve, reject)
      })
    },

    loadEpisode({commit, state}, number, {force} = {}) {
      if (state.episodeLoading) return Promise.resolve(false)
      const episode = _.find(state.episodes, e => e.number === number)
      if (episode && !episode.partial && !force) return Promise.resolve(false)

      return new Promise(async (resolve, reject) => {
        commit('START_EPISODE')
        try {
          let {data: episodeDetail} = await axios.get(
              `/episodes/${number}.json`)
          commit('SET_EPISODE', {episode: episodeDetail})
          resolve(episodeDetail)
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
