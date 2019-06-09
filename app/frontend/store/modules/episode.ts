import {ActionContext, Module} from 'vuex'
import Axios from 'axios'
import slugify from 'slugify'

import {RootState} from 'store'
import {Episode} from 'types'

export interface EpisodeState {
  episode?: Episode
  episodeLoading: boolean
  episodeError?: Error
}

const state: EpisodeState = {
  episode: null,
  episodeLoading: false,
  episodeError: null
}

const getters = {
  episode(state: EpisodeState): Episode | null { return state.episodeLoading ? null : state.episode },
  episodeLoading(state: EpisodeState): boolean { return state.episodeLoading },
  episodeError(state: EpisodeState): Error | null { return state.episodeError }
}

const mutations = {
  START_EPISODE(state: EpisodeState) {
    state.episodeLoading = true
  },

  SET_EPISODE(state: EpisodeState, {episode}: {episode: Episode}) {
    episode.slug = slugify(episode.title)
    state.episode = episode
    state.episodeLoading = false
  },

  SET_EPISODE_ERROR(state: EpisodeState, {error}: {error: Error}) {
    state.episode = null
    state.episodeError = error
    state.episodeLoading = false
  }
}

const actions = {
  loadEpisode({commit, state}: ActionContext<EpisodeState, RootState>, {number}: {number: number}): Promise<boolean> {
    if (state.episode && state.episode.number === number)
      return Promise.resolve(false)

    return new Promise<boolean>(async (resolve, reject) => {
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

const episode: Module<EpisodeState, RootState> = {state, getters, mutations, actions}
export default episode
