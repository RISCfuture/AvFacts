<template>
  <div class="field-error-pair">
    <textarea v-if="type === 'textarea'"
              v-bind="commonAttributes"
              v-model="buffer"
              :required="required"
              :maxlength="maxlength"
              :placeholder="placeholder"
              @focus="onFocus()"
              @blur="onBlur()"
              @change="onChange()" />

    <select v-else-if="type === 'select'"
            v-bind="commonAttributes"
            v-model="buffer"
            @focus="onFocus()"
            @blur="onBlur()"
            @change="onChange()">
      <slot />
    </select>

    <datetime v-else-if="type === 'datetime'"
              v-bind="commonAttributes"
              v-model="buffer"
              type="datetime"
              :value-zone="timezone"
              :zone="timezone"
              :phrases="{ok: 'OK', cancel: 'Cancel'}"
              :auto="true"
              :format="datetimeFormat"
              @focus="onFocus()"
              @blur="onBlur()"
              @change="onChange()" />

    <textarea v-else-if="type === 'markdown'"
              v-bind="commonAttributes"
              v-model="buffer"
              ref="markdownField"
              :required="required"
              :maxlength="maxlength"
              @focus="onFocus()"
              @blur="onBlur()"
              @change="onChange()" />

    <label v-else-if="type === 'checkbox'"
           class="checkbox-label">
      <input v-bind="commonAttributes"
             v-model="buffer"
             :type="type"
             @focus="onFocus()"
             @blur="onBlur()"
             @change="onChange()" />
      <slot />
    </label>

    <input v-else
           v-bind="commonAttributes"
           v-model="buffer"
           :type="type"
           :required="required"
           :maxlength="maxlength"
           :placeholder="placeholder"
           @focus="onFocus()"
           @blur="onBlur()"
           @change="onChange()" />

    <ul v-if="errors.length > 0" class="errors">
      <li v-for="error in errors">{{error}}</li>
    </ul>
  </div>
</template>

<script lang="ts">
  import Vue from 'vue'
  import * as SimpleMDE from 'simplemde'
  import {DateTime, DateTimeFormatOptions} from 'luxon'
  import Component from 'vue-class-component'
  import {Prop, Watch} from 'vue-property-decorator'

  import SmartFormBus from './SmartFormBus'
  import SmartForm from 'components/SmartForm/SmartForm.vue'

  @Component
  export default class SmartField<FormObject> extends Vue {
    $parent!: SmartForm<FormObject>
    $refs!: {
      markdownField: HTMLTextAreaElement
    }

    object?: FormObject = null
    buffer = ''
    MDE?: SimpleMDE = null

    @Prop({type: String, default: 'text'}) type: string
    @Prop({type: String, required: true}) field: string
    @Prop({type: Boolean, default: false}) required: boolean
    @Prop({type: Number}) maxlength: number
    @Prop({type: String}) placeholder: string
    @Prop({type: String, default: 'America/Los_Angeles'}) timezone: string

    private get name(): string { return `${this.$parent.objectName}[${this.field}]` }
    private get id(): string { return `${this.$parent.objectName}_${this.field}` }
    get errors(): string[] { return this.$parent.errors[this.field] || [] }
    private get invalid(): boolean { return this.errors.length > 0 }
    get datetimeFormat(): DateTimeFormatOptions { return DateTime.DATETIME_FULL }

    get commonAttributes() {
      return {
        name: this.name,
        id: this.id,
        class: {invalid: this.invalid},
        'v-model': this.buffer
      }
    }

    onFocus() { SmartFormBus.$emit('field-focus', this.field) }
    onBlur() { SmartFormBus.$emit('field-blur', this.field) }
    onChange() { SmartFormBus.$emit('value-updated', this.field, this.buffer) }

    private createMDE() {
      if (this.type !== 'markdown') return
      if (this.MDE) return
      this.MDE = new SimpleMDE({
        element: this.$refs.markdownField,
        blockStyles: {italic: '_'},
        spellChecker: false,
        status: false,
        forceSync: true
      })
    }

    @Watch('object')
    onObjectChanged() {
      if (this.type === 'file') return
      this.buffer = this.object[this.field]
      this.createMDE()
      // @ts-ignore: accessing a private `element` property
      if (this.MDE) this.MDE.element = this.$refs.markdownField
    }

    @Watch('buffer')
    onBufferChanged() {
      if (this.MDE) this.MDE.value(this.buffer)
      this.onChange()
    }

    mounted() {
      this.createMDE()
    }
  }
</script>
