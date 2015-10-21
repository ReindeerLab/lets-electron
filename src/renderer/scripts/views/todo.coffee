TodoModel = require '../models/todo'
DomUtils = require './dom-utils'

module.exports = do ->
  # props
  todoModel = new TodoModel()
  title = DomUtils.prop '#title'
  detail = DomUtils.prop '#detail'
  taskBox = DomUtils.prop '.task-box'

  # functions
  clearForm = ->
    title().val ''
    detail().val ''
  drawTasks = ->
    tasks = ''
    for task in todoModel.data
      tasks +=
        """
        <div class="task" data-seq="#{task.seq}">
          <p class="title">#{task.title}</p>
          <div class="detail">#{task.detail}</div>
        </div>
        """
    taskBox().html tasks

  render: ->
    # dom events
    $('#add').on 'click', ->
      todoModel.create title().val(), detail().val()
      clearForm()
    $('#reset').on 'click', clearForm

    # draw
    drawTasks()
