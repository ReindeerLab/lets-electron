LocalStorage = require './local-storage'

# タスクを管理
class TodoModel extends LocalStorage
  @seq
  constructor: ->
    super 'todo', [], true
    @setSequence()
  # シーケンス初期値設定
  setSequence: ->
    return @seq = 1 if @data.length < 1
    @seq = Math.max.apply null, @data.map (val) -> val.seq
  # シーケンスを発番
  sequence: ->
    @seq++
  # シーケンスから1件取得
  find: (seq) ->
    for val in @data
      return val if seq is val.seq
  # 登録
  create: (title, detail) ->
    @data.push {seq: @sequence(), title, detail, finished: false, deleted: false}
    @save()
  # 更新
  update: (todo) ->
    @data = @data.map (val) ->
      if todo.seq is val.seq then todo else val
    @save()
  # 削除
  delete: (seq) ->
    todo = @find seq
    todo.deleted = true
    @update todo
  # 完了
  finish: (seq) ->
    todo = @find seq
    todo.finished = true
    @update todo

module.exports = TodoModel
