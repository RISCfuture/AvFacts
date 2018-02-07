<template>
  <smart-form :method="method"
              :url="url"
              :object="scratchEpisode"
              objectName="episode">

    <div class="saving-spinner" v-if="saving">
      <img :src="spinnerURL" v-if="saving" />
    </div>

    <div class="fieldset">
      <div class="field-pair">
        <label for="episode_title">Title</label>
        <smart-field field="title" :required="true" :maxlength="255" />

        <label for="episode_title">Subtitle</label>
        <smart-field field="subtitle" :maxlength="255" />
      </div>

      <div class="field-pair">
        <label for="episode_author">Author</label>
        <smart-field field="author"
                     :maxlength="255"
                     :placeholder="channel.author" />

        <label for="episode_published_at">Publish at</label>
        <smart-field type="datetime" field="published_at" />

        <label>&nbsp;</label>
      </div>
    </div>

    <div class="fieldset">
      <div class="field-pair">
        <label for="episode_audio">Audio file</label>
        <div class="file-pair">
          <smart-field type="file" field="audio" />
          <p v-if="episode.audio">{{episode.audio.size |
            bytes}} &middot;
            {{episode.audio.duration | duration}}</p>
          <p v-else>&nbsp;</p>
        </div>

        <label for="episode_image">Image file</label>
        <div class="file-pair">
          <smart-field type="file" field="image" />
          <p v-if="episode.image">{{episode.image.size |
            bytes}} &middot;
            <span :class="{'too-small': imageTooSmall}">{{episode.image.width}}&times;{{episode.image.height}}</span></p>
          <p v-else>&nbsp;</p>
        </div>
      </div>

      <div class="field-pair">
        <smart-field type="checkbox" field="explicit">
          Contains explicit content
        </smart-field>
        <smart-field type="checkbox" field="blocked">
          Block this episode on iTunes Podcasts
        </smart-field>
      </div>
    </div>

    <label for="episode_summary">Summary</label>
    <smart-field type="text" field="summary" :maxlength="255" />

    <label for="episode_description" class="below-textarea">Description</label>
    <smart-field type="textarea" field="description" :required="true" />

    <label for="episode_script" class="below-textarea">Script</label>
    <smart-field type="markdown" field="script" />

    <div class="form-actions">
      <div class="left"></div>
      <div class="right">
        <input type="submit" name="commit" value="Save" />
      </div>
    </div>
  </smart-form>
</template>

<script>
  import _ from 'lodash'
  import {mapActions} from 'vuex'

  import Channel from 'channel.yml'

  import SmartForm from 'components/SmartForm/SmartForm'
  import SmartField from 'components/SmartForm/SmartField'
  import SmartFormBus from 'components/SmartForm/SmartFormBus'
  import Spinner from 'images/spinner.svg'

  const ITUNES_MIN_IMAGE_SIZE = 1400

  export default {
    props: ['episode'],

    data() {
      return {
        scratchEpisode: {},
        channel: Channel,
        spinnerURL: Spinner,
        saving: false
      }
    },

    components: {SmartForm, SmartField},

    computed: {
      method() { return (this.episode.number ? 'patch' : 'post') },

      url() {
        if (this.episode.number)
          return `/episodes/${this.episode.number}.json`
        else
          return `/episodes.json`
      },

      imageTooSmall() {
        return this.episode.image && (this.episode.image.width < ITUNES_MIN_IMAGE_SIZE || this.episode.image.height < ITUNES_MIN_IMAGE_SIZE)
      }
    },

    methods: {
      ...mapActions(['loadEpisodes']),

      refreshScratch() {
        this.scratchEpisode = _.pick(this.episode,
            ['title', 'subtitle', 'author', 'published_at', 'explicit',
             'blocked', 'summary', 'description', 'script'])
      }
    },

    mounted() {
      this.refreshScratch()
      SmartFormBus.$on('submit', () => this.saving = true)
      SmartFormBus.$on('complete', () => {
        this.saving = false
        this.loadEpisodes({restart: false})
      })
    },

    watch: {
      episode() { this.refreshScratch() }
    }
  }
</script>

<style lang="scss">
  @import "../../styles/vars";

  #episode_description {
    height: 100px;
  }

  form .CodeMirror {
    height: 400px;
  }

  form {
    position: relative;
  }

  .saving-spinner {
    position: absolute;
    left: 0;
    top: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(255, 255, 255, 0.8);
    display: flex;
    flex-flow: row nowrap;
    align-items: center;
    justify-content: center;
    z-index: $banner-layer - 1;

    img { flex: 0 0 auto; }
  }

  .too-small {
    color: $error-color;
  }

  label.below-textarea {
    margin-top: 20px;
  }
</style>
