LocalStorage = require './local-storage'

class TodoModel extends LocalStorage
  @seq
  constructor: ->
    super 'todo', [], true
    @setSequence()
  sequence: ->
    @seq++
  setSequence: ->
    return @seq = 1 if @data.length < 1
    @seq = Math.max.apply null, @data.map (val) -> val.seq
  find: (seq) ->
    for val in @data
      return val if seq is val.seq
  create: (title, task) ->
    @data.push {seq: @sequence(), title, task, finished: false, deleted: false}
  update: (todo) ->
    @data = @data.map (val) ->
      if todo.seq is val.seq then todo else val
    @save()
  delete: (seq) ->
    todo = @find seq
    todo.deleted = true
    @update todo
  finish: (seq) ->
    todo = @find seq
    todo.finished = true
    @update todo

module.exports = TodoModel
