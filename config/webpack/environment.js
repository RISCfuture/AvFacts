const path = require('path')

const { environment } = require('@rails/webpacker')
const erb =  require('./loaders/erb')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.loaders.prepend('erb', erb)
module.exports = environment

const yaml =  require('./loaders/yaml')
environment.loaders.prepend('yaml', yaml)
environment.config.merge({
  resolve: {
    alias: {
      'channel.yml$': path.resolve(__dirname, '../channel.yml')
    }
  }
})
