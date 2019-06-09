import {ActionContext, Module} from 'vuex'
import Axios, {AxiosError} from 'axios'

import {RootState} from 'store'

export interface SessionState {
  sessionUsername?: string
  sessionToken?: string
  sessionError?: AxiosError
}

const state: SessionState = {
  sessionUsername: null,
  sessionToken: null,
  sessionError: null
}

const getters = {
  username(state: SessionState): string | null { return state.sessionUsername },
  token(state: SessionState): string | null { return state.sessionToken },
  isAuthenticated(state: SessionState): boolean { return state.sessionUsername != null },
  sessionError(state: SessionState): AxiosError | null { return state.sessionError }
}

const mutations = {
  START_AUTHENTICATION(state: SessionState) {
    state.sessionError = null
  },

  AUTHENTICATE_SESSION(state: SessionState, {username, token}: {username: string, token: string}) {
    state.sessionUsername = username
    state.sessionToken = token
    state.sessionError = null
  },

  SET_SESSION_ERROR(state: SessionState, {error}: {error: AxiosError}) {
    state.sessionUsername = null
    state.sessionToken = null
    state.sessionError = error
  },

  CLEAR_SESSION(state: SessionState) {
    state.sessionUsername = null
    state.sessionToken = null
    state.sessionError = null
  }
}

const actions = {
  loadSession({commit, state}: ActionContext<SessionState, RootState>, {skipIfAlreadyLoaded}: {skipIfAlreadyLoaded: boolean} = {skipIfAlreadyLoaded: false}): Promise<boolean> {
    if (skipIfAlreadyLoaded && state.sessionUsername && state.sessionToken)
      return Promise.resolve(false)

    return new Promise<boolean>(async (resolve, reject) => {
      try {
        let {data} = await Axios.get('/session.json')
        if (data.username && data.token)
          commit('AUTHENTICATE_SESSION', data)
        else
          commit('CLEAR_SESSION')
        resolve(true)
      } catch (error) {
        commit('SET_SESSION_ERROR', {error})
        reject(error)
      }
    })
  },

  resetSessionError({commit}: ActionContext<SessionState, RootState>) {
    commit('START_AUTHENTICATION')
  },

  login({commit}: ActionContext<SessionState, RootState>, fields: {[name: string]: string}): Promise<boolean> {
    return new Promise<boolean>(async (resolve, reject) => {
      commit('START_AUTHENTICATION')
      try {
        let {data, status} = await Axios.post('/session.json', fields)
        if (status === 200) {
          commit('AUTHENTICATE_SESSION', data)
          resolve(true)
        } else {
          commit('CLEAR_SESSION')
          resolve(false)
        }
      } catch (error) {
        commit('SET_SESSION_ERROR', {error})
        reject(error)
      }
    })
  },

  logout({commit}: ActionContext<SessionState, RootState>): Promise<void> {
    return new Promise<void>(async (resolve, reject) => {
      try {
        await Axios.delete('/session.json')
        commit('CLEAR_SESSION')
        resolve()
      } catch (error) {
        reject(error)
      }
    })
  }
}

const session: Module<SessionState, RootState> = {state, getters, mutations, actions}
export default session
