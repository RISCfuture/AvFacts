import Vuex from 'vuex'
import createLogger from 'vuex/dist/logger'

const debug = process.env.NODE_ENV !== 'production'

export default function createStore(modules) {
  return new Vuex.Store({modules, strict: debug, plugins: debug ? [createLogger()] : []})
}
