export default {
  state: {
    loginLightboxShown: false,
  },

  getters: {
    loginLightboxShown: state => state.loginLightboxShown,
  },

  mutations: {
    SHOW_LOGIN_LIGHTBOX(state) {
      state.loginLightboxShown = true
    },

    HIDE_LOGIN_LIGHTBOX(state) {
      state.loginLightboxShown = false
    },

    TOGGLE_LOGIN_LIGHTBOX(state) {
      state.loginLightboxShown = !state.loginLightboxShown
    },
  },

  actions: {
    showLoginLightbox({commit}) {
      commit('SHOW_LOGIN_LIGHTBOX')
    },

    hideLoginLightbox({commit}) {
      commit('HIDE_LOGIN_LIGHTBOX')
    },

    toggleLoginLightbox({commit}) {
      commit('TOGGLE_LOGIN_LIGHTBOX')
    },
  }
}
