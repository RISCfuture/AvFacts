process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

environment.config.merge({
  resolve: {
    alias: {
      'vue$': 'vue/dist/vue.esm.js'
    }
  }
})

module.exports = environment.toWebpackConfig()
