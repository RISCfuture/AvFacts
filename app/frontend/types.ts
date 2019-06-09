export interface Image {
  preview_url: string
  width: number
  height: number
  size: number
}

export interface Audio {
  url: string
  content_type: string
  byte_size: number
}

export interface Episode {
  id: number
  slug?: string
  number: number

  title: string
  subtitle?: string
  summary?: string
  author?: string
  description: string
  credits?: string

  published_at?: string

  explicit: boolean
  blocked: boolean

  script?: string
  'script?'?: boolean

  image?: Image

  audio?: {
    duration: number
    size: number

    mp3: Audio
    aac: Audio
  }
}

export interface ScratchEpisode {
  title?: string
  subtitle?: string
  author?: string
  published_at?: string
  explicit?: string
  blocked?: string
  summary?: string
  description?: string
  script?: string
  credits?: string
} //TODO derive from Episode somehow?
