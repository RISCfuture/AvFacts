<template>
  <form @submit.prevent="save" ref="form">
    <ul v-if="errors.base" class="errors">
      <li v-for="error in errors.base">{{error}}</li>
    </ul>
    <slot></slot>
  </form>
</template>

<script>
  import axios from 'axios'

  import SmartFormBus from './SmartFormBus'

  export default {
    props: {
      url: {type: String, required: true},
      method: {type: String, default: 'post'},
      object: {type: Object, required: true},
      objectName: {type: String, required: true}
    },

    data() {
      return {
        errors: {},
        focused: null
      }
    },

    computed: {
      formData() {
        let formData = new FormData(this.$refs.form)
        this.$children.forEach(child => {
          if (child.type !== 'file') return
          if (child.buffer === '') return
          formData.append(child.field, child.buffer)
        })
        return formData
      }
    },

    methods: {
      save() {
        SmartFormBus.$emit('submit')
        axios[this.method](this.url, this.formData).then(response => {
          SmartFormBus.$emit('complete')
          SmartFormBus.$emit('success', response)
        }).catch(error => {
          SmartFormBus.$emit('complete')
          SmartFormBus.$emit('error', error)
          if (error.response.status === 422)
            this.errors = error.response.data.errors
        })
      }
    },

    mounted() {
      SmartFormBus.$on('value-updated', (field, value) => this.object[field] = value)
      this.$children.forEach(child => child.object = this.object)
    },

    watch: {
      object() {
        this.$children.forEach(child => child.object = this.object)
      }
    }
  }
</script>
