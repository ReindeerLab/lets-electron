remote = global.require 'remote'
dialog = remote.require 'dialog'

TaskModel = require '../models/task'
DomUtils = require '../utils/dom-utils'
StringUtils = require '../utils/string-utils'

module.exports = do ->
  # constants
  REGISTER_SELECTOR = '#side-nav-register'

  # props
  model = new TaskModel()
  title = DomUtils.prop "#{REGISTER_SELECTOR} [name=title]"
  detail = DomUtils.prop "#{REGISTER_SELECTOR} [name=detail]"
  taskBox = DomUtils.prop '.task-box'
  task = DomUtils.prop '.task'

  # functions
  # タスク登録
  createTask = (title, detail) ->
    if StringUtils.isEmpty title || StringUtils.isEmpty detail
      return dialog.showErrorBox '入力エラー', '全ての項目を埋めてください'
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
    task().off().on 'click', ->
      console.log DomUtils.prop(@)().attr 'data-seq' #FIXME

  # タスク詳細を描画
  drawDetail = (seq) ->
    task model.find seq

  # 初回描画
  render: ->
    # dom events
    registForm = DomUtils.prop REGISTER_SELECTOR
    registForm().on 'submit', ->
      createTask title().val(), detail().val()
      false

    # draw phase
    drawTasks()
