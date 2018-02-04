import axios from 'axios'

export default {
  state: {
    sessionUsername: null,
    sessionToken: null,
    sessionError: null
  },

  getters: {
    username: state => state.sessionUsername,
    token: state => state.sessionToken,
    isAuthenticated: state => state.sessionUsername != null,
    sessionError: state => state.sessionError
  },

  mutations: {
    START_AUTHENTICATION(state) {
      state.sessionError = null
    },

    AUTHENTICATE_SESSION(state, {username, token}) {
      state.sessionUsername = username
      state.sessionToken = token
      state.sessionError = null
    },

    SET_SESSION_ERROR(state, {error}) {
      state.sessionUsername = null
      state.sessionToken = null
      state.sessionError = error
    },

    CLEAR_SESSION(state) {
      state.sessionUsername = null
      state.sessionToken = null
      state.sessionError = null
    }
  },

  actions: {
    loadSession({commit, state}, {skipIfAlreadyLoaded} = {}) {
      if (skipIfAlreadyLoaded && state.sessionUsername && state.sessionToken)
        return Promise.resolve(false)

      return new Promise((resolve, reject) => {
        axios.get('/session.json').then(({data}) => {
          if (data.username && data.token)
            commit('AUTHENTICATE_SESSION', data)
          else
            commit('CLEAR_SESSION')
          resolve(true)
        }).catch(error => {
          commit('SET_SESSION_ERROR', {error})
          reject(error)
        })
      })
    },

    resetSessionError({commit}) {
      commit('START_AUTHENTICATION')
    },

    login({commit}, fields) {
      return new Promise((resolve, reject) => {
        commit('START_AUTHENTICATION')
        axios.post('/session.json', fields).then(({data, status}) => {
          if (status === 200) {
            commit('AUTHENTICATE_SESSION', data)
            resolve(true)
          } else {
            commit('CLEAR_SESSION')
            resolve(false)
          }
        }).catch(error => {
          commit('SET_SESSION_ERROR', {error})
          reject(error)
        })
      })
    },

    logout({commit}) {
      return new Promise((resolve, reject) => {
        axios.delete('/session.json')
             .then(() => {
               commit('CLEAR_SESSION')
               resolve()
             })
             .catch(error => reject(error))
      })
    }
  }
}
