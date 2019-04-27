/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'core-js/stable'
import 'regenerator-runtime/runtime'

import {RAILS_ENV, BUGSNAG_API_KEY} from 'config/constants.js.erb'

import Vue from 'vue'

import bugsnag from 'bugsnag-js'
import bugsnagVue from 'bugsnag-vue'
if (RAILS_ENV === 'production') {
  const BugsnagClient = bugsnag(BUGSNAG_API_KEY)
  bugsnag.releaseStage = RAILS_ENV
  bugsnag.notifyReleaseStages = ['production']
  BugsnagClient.use(bugsnagVue(Vue))
}

import store from 'store/index'

import VueRouter from 'vue-router'
import routes from 'routes'
Vue.use(VueRouter)
const router = new VueRouter({routes, mode: 'history'})

import Datetime from 'vue-datetime'
import 'vue-datetime/dist/vue-datetime.css'
Vue.use(Datetime)

import InfiniteScroll from 'vue-infinite-scroll'
Vue.use(InfiniteScroll)

import 'config/addCSRFTokens'
import 'config/focusDirective'
import 'config/filters'

import Layout from 'views/Layout.vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    render: create => create(Layout),
    router, store
  }).$mount('#app')
})

import 'normalize.css'
import 'styles/fonts.scss'
import 'styles/common.scss'
import 'styles/forms.scss'
import 'styles/transitions.scss'

import 'simplemde/dist/simplemde.min.css'
