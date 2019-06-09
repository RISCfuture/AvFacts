import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)

export interface RootState {}

import episodes from './modules/episodes'
import episode from './modules/episode'
import session from './modules/session'
import loginLightbox from './modules/loginLightbox'

import createStore from './create'

export default createStore({episodes, episode, session, loginLightbox})
