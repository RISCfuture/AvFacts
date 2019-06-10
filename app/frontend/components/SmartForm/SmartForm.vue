<template>
  <form @submit.prevent="save" ref="form">
    <ul v-if="errors.base" class="errors">
      <li v-for="error in errors.base">{{error}}</li>
    </ul>
    <slot></slot>
  </form>
</template>

<script lang="ts">
  import Axios, {Method} from 'axios'
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import {Prop, Watch} from 'vue-property-decorator'

  import SmartFormBus from './SmartFormBus'
  import SmartField from 'components/SmartForm/SmartField.vue'

  @Component
  export default class SmartForm<FormObject> extends Vue {
    $children!: SmartField<FormObject>[]
    $refs!: {
      form: HTMLFormElement
    }

    @Prop({type: String, required: true}) url: string
    @Prop({type: String, default: 'post'}) method: Method
    @Prop({type: Object, required: true}) object: FormObject
    @Prop({type: String, required: true}) objectName: string

    errors: {[field: string]: string[]} = {}

    get formData(): FormData {
      let formData = new FormData(this.$refs.form)
      this.$children.forEach(child => {
        if (child.type !== 'file') return
        if (child.buffer === '') return
        formData.append(child.field, child.buffer)
      })
      return formData
    }

    async save() {
      SmartFormBus.$emit('submit')
      try {
        let response = await Axios.request<FormObject>({method: this.method, url: this.url, data: this.formData})
        SmartFormBus.$emit('complete')
        SmartFormBus.$emit('success', response)
      } catch (error) {
        SmartFormBus.$emit('complete')
        SmartFormBus.$emit('error', error)
        if (error.response.status === 422)
          this.errors = error.response.data.errors
      }
    }

    mounted() {
      SmartFormBus.$on('value-updated', (field, value) => this.object[field] = value)
      this.$children.forEach(child => child.object = this.object)
    }

    @Watch('object')
    onObjectChanged() {
      this.$children.forEach(child => child.object = this.object)
    }
  }
</script>
