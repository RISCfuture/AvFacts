import {RouteConfig} from 'vue-router'

import EpisodesList from 'views/Episodes/List/Index.vue'
import EpisodesNew from 'views/Episodes/New.vue'
import EpisodesShow from 'views/Episodes/Show.vue'
import EpisodesEdit from 'views/Episodes/Edit.vue'
import EpisodesScript from 'views/Episodes/Script.vue'
import About from 'views/About.vue'

import Layout from 'views/Layout/Layout.vue'
import FourOhFour from 'views/error/404.vue'

const routes: RouteConfig[] = [
  {
    path: '/', component: Layout, children: [
      {path: '', component: EpisodesList, name: 'episodes_list'},
      {path: '/upload', component: EpisodesNew, name: 'episodes_new'},
      {path: '/episodes/:id', component: EpisodesShow},
      {path: '/episodes/:id/edit', component: EpisodesEdit, name: 'episodes_edit'},
      {path: '/episodes/:id/script', component: EpisodesScript, name: 'episodes_script'},
      {path: '/episodes/:id/:slug', component: EpisodesShow, name: 'episodes_show'},
      {path: '/about', component: About, name: 'about'},
    ]
  },

  {path: "*", component: FourOhFour}
]

export default routes
