TodoModel = require '../models/todo'
DomUtils = require './dom-utils'

module.exports = do ->
  # constants
  REGISTER_SELECTOR = '#side-nav-register'

  # props
  todoModel = new TodoModel()
  registForm = DomUtils.prop REGISTER_SELECTOR
  title = DomUtils.prop "#{REGISTER_SELECTOR} [name=title]"
  detail = DomUtils.prop "#{REGISTER_SELECTOR} [name=detail]"
  taskBox = DomUtils.prop '.task-box'

  # functions
  # 入力項目を削除
  clearForm = ->
    title().val ''
    detail().val ''
  # タスク一覧を描画
  drawTasks = ->
    tasks = ''
    for task in todoModel.data
      createdAt = new Date task.created_at
      tasks += """<div class="task" data-seq="#{task.seq}">
        <p class="created-at">#{createdAt.getFullYear()}/#{createdAt.getMonth() + 1}/#{createdAt.getDate()}</p>
        <p class="title">#{task.title}</p></div>"""
    taskBox().html tasks

  # 初回描画
  render: ->
    # dom events
    registForm().on 'submit', ->
      todoModel.create title().val(), detail().val()
      clearForm()
      drawTasks()
      false
    # draw phase
    drawTasks()
