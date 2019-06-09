import Vuex from 'vuex'
import createLogger from 'vuex/dist/logger'

import {RootState} from 'store/index'

const debug = process.env.NODE_ENV !== 'production'

export default function createStore(modules) {
  return new Vuex.Store<RootState>({modules, strict: debug, plugins: debug ? [createLogger()] : []})
}
