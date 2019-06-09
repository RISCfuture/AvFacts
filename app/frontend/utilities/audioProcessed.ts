import * as _ from 'lodash'
import {Episode} from 'types'

export default function audioProcessed(episode: Episode) {
  return _.has(episode, 'audio.mp3') && _.has(episode, 'audio.aac')
}
