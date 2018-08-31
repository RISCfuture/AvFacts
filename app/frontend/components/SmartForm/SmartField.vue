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

<script>
  import SimpleMDE from 'simplemde'
  import {DateTime} from 'luxon'

  import SmartFormBus from './SmartFormBus'

  export default {
    data() {
      return {
        object: null,
        buffer: '',
        MDE: null
      }
    },

    props: {
      type: {type: String, default: 'text'},
      field: {type: String, required: true},
      required: {type: Boolean, default: false},
      maxlength: {type: Number},
      placeholder: {type: String},
      timezone: {type: String, default: 'America/Los_Angeles'}
    },

    computed: {
      name() { return `${this.$parent.objectName}[${this.field}]` },
      id() { return `${this.$parent.objectName}_${this.field}` },
      errors() { return this.$parent.errors[this.field] || [] },
      invalid() { return this.errors.length > 0 },
      datetimeFormat() { return DateTime.DATETIME_FULL },

      commonAttributes() {
        return {
          name: this.name,
          id: this.id,
          class: {invalid: this.invalid},
          'v-model': this.buffer
        }
      }
    },

    methods: {
      onFocus() {SmartFormBus.$emit('field-focus', this.field)},
      onBlur() {SmartFormBus.$emit('field-blur', this.field)},
      onChange() {SmartFormBus.$emit('value-updated', this.field, this.buffer)},

      createMDE() {
        if (this.type !== 'markdown') return
        if (this.MDE) return
        this.MDE = new SimpleMDE({
          element: this.$refs.markdownField,
          blockStyles: {italic: '_'},
          spellChecker: false,
          status: false,
          forceSync: true
        })
      },
    },

    watch: {
      object() {
        if (this.type === 'file') return
        this.buffer = this.object[this.field]
        this.createMDE()
        if (this.MDE) this.MDE.element = this.$refs.markdownField
      },
      buffer() {
        if (this.MDE) this.MDE.value(this.buffer)
        this.onChange()
      }
    },

    mounted() {
      this.createMDE()
    }
  }
</script>
