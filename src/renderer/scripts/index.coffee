global.$ = global.jQuery = require 'jquery'

taskView = require './views/task'

$ ->
  taskView.render()
