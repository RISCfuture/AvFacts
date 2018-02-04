const environment = require('./environment')

environment.config.merge({
  resolve: {
    alias: {
      'vue$': 'vue/dist/vue.esm.js'
    }
  }
})

module.exports = environment.toWebpackConfig()
