LocalStorage = require './local-storage'

# タスクを管理
class TaskModel extends LocalStorage
  @seq
  constructor: ->
    super 'tasks', [], true
    @setSequence()
  # シーケンス初期値設定
  setSequence: ->
    return @seq = 1 if @data.length < 1
    @seq = Math.max.apply(null, @data.map (val) -> val.seq) + 1
  # シーケンスを発番
  sequence: ->
    @seq++
  # シーケンスから1件取得
  find: (seq) ->
    for val in @data
      return val if seq is val.seq
  # 登録
  create: (title, detail) ->
    @data.push
      seq: @sequence()
      title: title
      detail: detail
      finished: false
      deleted: false
      created_at: new Date().toISOString()
      updated_at: null
      finished_at: null
      deleted_at: null
    @save()
  # 更新
  update: (task) ->
    @data = @data.map (val) ->
      if task.seq is val.seq then task else val
    @save()
  # 削除
  delete: (seq) ->
    task = @find seq
    task.deleted = true
    task.deleted_at = new Date().toISOString()
    @update task
  # 完了
  finish: (seq) ->
    task = @find seq
    task.finished = true
    task.finished_at = new Date().toISOString()
    @update task

module.exports = TaskModel
