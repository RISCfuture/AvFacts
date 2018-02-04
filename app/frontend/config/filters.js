import Vue from 'vue'

import numeral from 'numeral'

import moment from 'moment'
import momentDurationFormatSetup from 'moment-duration-format'
momentDurationFormatSetup(moment)

Vue.filter('integer', function(value) {
  if (!value) return ''
  return numeral(value).format('0,0')
})

Vue.filter('duration', function(value) {
  if (!value) return ''
  return moment.duration(value*1000).format()
})

Vue.filter('date', function(value) {
  if (!value) return ''
  return moment(value).format('MMM D, YYYY')
})

Vue.filter('bytes', function(value) {
  if (!value) return ''
  return numeral(value).format('0 b')
})
