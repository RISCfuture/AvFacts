import Axios from 'axios'

const CSRF_TOKEN_HEADER = 'X-CSRF-Token'

Axios.interceptors.request.use(function(config) {
  if (config.method !== 'get') {
    // const tokenName = document.querySelector('meta[name=csrf-param]')
    //                         .getAttribute('content')
    const tokenValue = document.querySelector('meta[name=csrf-token]')
                             .getAttribute('content')
    config.headers[CSRF_TOKEN_HEADER] = tokenValue
  }

  return config
})
