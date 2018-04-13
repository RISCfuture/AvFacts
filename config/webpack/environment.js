const path = require('path')

const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')

const yaml =  require('./loaders/yaml')
environment.loaders.append('yaml', yaml)
environment.config.merge({
  resolve: {
    alias: {
      'channel.yml$': path.resolve(__dirname, '../channel.yml')
    }
  }
})

environment.loaders.append('vue', vue)
module.exports = environment
