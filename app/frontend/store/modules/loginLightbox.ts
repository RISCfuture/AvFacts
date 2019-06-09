import {ActionContext, Module} from 'vuex'
import {RootState} from 'store'

export interface LoginLightboxState {
  loginLightboxShown: boolean
}

const state: LoginLightboxState = {
  loginLightboxShown: false,
}

const getters = {
  loginLightboxShown(state: LoginLightboxState): boolean { return state.loginLightboxShown },
}

const mutations = {
  SHOW_LOGIN_LIGHTBOX(state: LoginLightboxState) {
    state.loginLightboxShown = true
  },

  HIDE_LOGIN_LIGHTBOX(state: LoginLightboxState) {
    state.loginLightboxShown = false
  },

  TOGGLE_LOGIN_LIGHTBOX(state: LoginLightboxState) {
    state.loginLightboxShown = !state.loginLightboxShown
  },
}

const actions = {
  showLoginLightbox({commit}: ActionContext<LoginLightboxState, RootState>) {
    commit('SHOW_LOGIN_LIGHTBOX')
  },

  hideLoginLightbox({commit}: ActionContext<LoginLightboxState, RootState>) {
    commit('HIDE_LOGIN_LIGHTBOX')
  },

  toggleLoginLightbox({commit}: ActionContext<LoginLightboxState, RootState>) {
    commit('TOGGLE_LOGIN_LIGHTBOX')
  },
}

const loginLightbox: Module<LoginLightboxState, RootState> = {state, getters, mutations, actions}
export default loginLightbox
