const path = require('path')

const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')

environment.loaders.append('vue', vue)

const yaml =  require('./loaders/yaml')
environment.loaders.append('yaml', yaml)
environment.config.merge({
  resolve: {
    alias: {
      'channel.yml$': path.resolve(__dirname, '../channel.yml')
    }
  }
})

module.exports = environment
