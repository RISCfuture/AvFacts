import EpisodesList from 'views/Episodes/List/Index.vue'
import EpisodesNew from 'views/Episodes/New.vue'
import EpisodesEdit from 'views/Episodes/Edit.vue'
import EpisodesScript from 'views/Episodes/Script.vue'
import About from 'views/About.vue'

import Layout from 'views/Layout/Layout.vue'
import PageNotFound from 'views/PageNotFound.vue'

export default [
  {
    path: '/', component: Layout, children: [
      {path: '', component: EpisodesList, name: 'episodes_list'},
      {path: '/upload', component: EpisodesNew, name: 'episodes_new'},
      {path: '/episodes/:id', component: EpisodesEdit, name: 'episodes_edit'},
      {path: '/episodes/:id/script', component: EpisodesScript, name: 'episodes_script'},
      {path: '/about', component: About, name: 'about'},
    ]
  },

  {path: "*", component: PageNotFound}
]
