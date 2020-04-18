import Axios from 'axios'

Axios.interceptors.request.use(config => {
  if (config.method !== 'get' && document.querySelector('meta[name=csrf-token]')) {
    const tokenName = document.querySelector('meta[name=csrf-param]')
        .getAttribute('content')
    const tokenValue = document.querySelector('meta[name=csrf-token]')
        .getAttribute('content')
    config.headers[tokenName] = tokenValue
  }

  return config
})
