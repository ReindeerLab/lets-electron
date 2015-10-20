global.$ = global.jQuery = require 'jquery'

todo = require './views/todo'

$ ->
  todo.render()
