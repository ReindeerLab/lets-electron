remote = global.require 'remote'
dialog = remote.require 'dialog'

TaskModel = require '../models/task'
DomUtils = require '../utils/dom-utils'

module.exports = do ->
  # constants
  REGISTER_SELECTOR = '#side-nav-register'

  # props
  model = new TaskModel()
  registForm = DomUtils.prop REGISTER_SELECTOR
  title = DomUtils.prop "#{REGISTER_SELECTOR} [name=title]"
  detail = DomUtils.prop "#{REGISTER_SELECTOR} [name=detail]"
  taskBox = DomUtils.prop '.task-box'

  # functions
  # タスク登録
  registTask = (title, detail) ->
    model.create title, detail
    clearForm()
    drawTasks()

  # 入力項目を削除
  clearForm = ->
    title().val ''
    detail().val ''

  # タスク一覧を描画
  drawTasks = ->
    tasks = model.data.map (task) ->
      createdAt = new Date task.created_at
      """
      <div class="task" data-seq="#{task.seq}">
        <p class="created-at">#{createdAt.getFullYear()}/#{createdAt.getMonth() + 1}/#{createdAt.getDate()}</p>
        <p class="title">#{task.title}</p>
      </div>
      """
    taskBox().html tasks.join ''

  # 初回描画
  render: ->
    # dom events
    registForm().on 'submit', ->
      registTask title().val(), detail().val()
      false

    # draw phase
    drawTasks()
