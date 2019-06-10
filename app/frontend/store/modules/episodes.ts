import {ActionContext, Module} from 'vuex'
import Axios from 'axios'
import * as _ from 'lodash'
import slugify from 'slugify'

import {Episode} from 'types'
import {RootState} from 'store'

export interface EpisodesState {
  episodes: Episode[],
  episodesLoading: boolean,
  episodesError?: Error,
  episodesFilter?: string,
  nextURL: string
}

const state: EpisodesState = {
  episodes: [],
  episodesLoading: false,
  episodesError: null,
  episodesFilter: null,
  nextURL: `/episodes.json`
}

const getters = {
  episodes(state: EpisodesState): Episode[] { return state.episodesLoading ? [] : state.episodes },
  episodesError(state: EpisodesState): Error | null { return state.episodesError },
  episodesLoading(state: EpisodesState, getters: any, rootState: RootState, rootGetters: any): boolean {
    return state.episodesLoading || rootGetters.episodeLoading
  }
}

const mutations = {
  RESET_EPISODES(state: EpisodesState) {
    state.episodes = []
    state.episodesLoading = false
    state.episodesError = null
    state.nextURL = `/episodes.json?filter=${state.episodesFilter || ''}`
  },

  START_EPISODES(state: EpisodesState) {
    state.episodesLoading = true
  },

  APPEND_EPISODES(state: EpisodesState, {page}: {page: Episode[]}) {
    page.forEach(e => e.slug = slugify(e.title))
    state.episodes = state.episodes.concat(page)
  },

  FINISH_EPISODES(state: EpisodesState) {
    state.episodesLoading = false
  },

  SET_EPISODES_ERROR(state: EpisodesState, {error}: {error: Error}) {
    state.episodes = []
    state.episodesLoading = false
    state.episodesError = error
    state.nextURL = `/episodes.json?filter=${state.episodesFilter || ''}`
  },

  SET_FILTER(state: EpisodesState, {filter}: {filter?: string}) {
    state.episodesFilter = filter
    state.nextURL = `/episodes.json?filter=${state.episodesFilter || ''}`
  },

  SET_NEXT_PAGE_URL(state: EpisodesState, {url}: {url: string}) {
    state.nextURL = url
  },

  SET_EPISODE_IN_EPISODES(state: EpisodesState, {episode}: {episode: Episode}) {
    let newEpisodes: Episode[] = []
    state.episodes.forEach((existingEpisode, index) => {
      if (existingEpisode.id === episode.id)
        newEpisodes.push(episode)
      else
        newEpisodes.push(existingEpisode)
    })

    state.episodes = newEpisodes
  }
}

const actions = {
  setEpisodeInEpisodes({commit, state}: ActionContext<EpisodesState, RootState>, {episode}: {episode: Episode}) {
    commit('SET_EPISODE_IN_EPISODES', {episode})
  },

  loadEpisodes({commit, state}: ActionContext<EpisodesState, RootState>, {restart}: {restart: boolean} = {restart: false}): Promise<boolean> {
    return new Promise<boolean>(async (resolve, reject) => {
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

  setFilter({commit}: ActionContext<EpisodesState, RootState>, {filter}: {filter?: string} = {}) {
    return new Promise(resolve => {
      commit('SET_FILTER', {filter})
      resolve(true)
    })
  }
}

const episodes: Module<EpisodesState, RootState> = {state, getters, mutations, actions}
export default episodes
