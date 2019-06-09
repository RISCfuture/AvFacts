declare module 'config/secrets.js' {
  interface Secrets {
    bugsnagAPIKey: string
  }
  const secrets: Secrets
  export default secrets
}

declare module 'channel.yml' {
  interface Channel {
    title: string
    language: string
    copyright: string
    webmaster: string
    summary: string
    subtitle: string
    owner: {
      name: string
      email: string
    }
    author: string
    explicit: boolean
    itunes_category: {
      [category: string]: string
    }
  }

  const channel: Channel
  export default channel
}

declare module '*.png' {
  const URL: string
  export default URL
}

declare module '*.jpg' {
  const URL: string
  export default URL
}
