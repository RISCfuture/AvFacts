<template>
  <smart-form :method="method"
              :url="url"
              :object="scratchEpisode"
              objectName="episode">

    <page-loading v-if="saving" />

    <div class="fieldset">
      <div class="field-pair">
        <label for="episode_title">Title</label>
        <smart-field field="title"
                     :required="true"
                     :maxlength="255"
                     data-cy="titleField" />

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
          <smart-field type="file" field="audio" data-cy="audioField" />
          <p v-if="episode.audio">{{episode.audio.size | bytes}} &middot;
            {{episode.audio.duration | duration}}</p>
          <p v-else>&nbsp;</p>
        </div>

        <label for="episode_image">Image file</label>
        <div class="file-pair">
          <smart-field type="file" field="image" data-cy="imageField" />
          <p v-if="episode.image">{{episode.image.size |
            bytes}} &middot;
            <span :class="{'too-small': imageTooSmall}">{{episode.image.width}}&times;{{episode.image.height}}</span>
          </p>
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
    <smart-field type="textarea"
                 field="description"
                 :required="true"
                 :maxlength="4000"
                 data-cy="descriptionField" />

    <label for="episode_credits" class="below-textarea">Credits</label>
    <smart-field type="textarea" field="credits" :maxlength="1000" />

    <label for="episode_script" class="below-textarea">Script</label>
    <smart-field type="markdown" field="script" />

    <div class="form-actions">
      <div class="left"></div>
      <div class="right">
        <input type="submit"
               name="commit"
               value="Save"
               data-cy="podcastSubmitButton" />
      </div>
    </div>
  </smart-form>
</template>

<script lang="ts">
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Prop, Watch} from 'vue-property-decorator'
  import {Action} from 'vuex-class'
  import * as _ from 'lodash'

  import {Episode, ScratchEpisode} from 'types'
  import Channel from 'channel.yml'
  import SmartForm from 'components/SmartForm/SmartForm'
  import SmartField from 'components/SmartForm/SmartField'
  import SmartFormBus from 'components/SmartForm/SmartFormBus'
  import PageLoading from 'components/PageLoading.vue'

  const ITUNES_MIN_IMAGE_SIZE = 1400

  @Component({
    components: {SmartForm, SmartField, PageLoading}
  })
  export default class Form extends Vue {
    @Prop({required: true}) episode: Episode

    scratchEpisode: ScratchEpisode = {}
    channel = Channel
    saving = false

    get method(): string {
      return (this.episode.number ? 'patch' : 'post')
    }

    get url(): string {
      if (this.episode.number)
        return `/episodes/${this.episode.number}.json`
      else
        return `/episodes.json`
    }

    get imageTooSmall(): boolean {
      return this.episode.image && (this.episode.image.width < ITUNES_MIN_IMAGE_SIZE || this.episode.image.height < ITUNES_MIN_IMAGE_SIZE)
    }

    @Action loadEpisodes: (params: { restart: boolean }) => Promise<boolean>
    @Action setEpisode: (params: { episode: Episode }) => void
    @Action setEpisodeInEpisodes: (params: { episode: Episode }) => void

    private refreshScratch() {
      this.scratchEpisode = _.pick(this.episode,
          ['title', 'subtitle', 'author', 'published_at', 'explicit',
            'blocked', 'summary', 'description', 'script', 'credits']) as object
    }

    mounted() {
      this.refreshScratch()
      SmartFormBus.$on('submit', () => this.saving = true)
      SmartFormBus.$on('complete', () => this.saving = false)

      SmartFormBus.$on('success', response => {
        this.setEpisode({episode: response.data})
        this.setEpisodeInEpisodes({episode: response.data})
      })
    }

    @Watch('episode')
    onEpisodeChanged() {
      this.refreshScratch()
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

  .too-small {
    color: $error-color;
  }

  label.below-textarea {
    margin-top: 20px;
  }
</style>
