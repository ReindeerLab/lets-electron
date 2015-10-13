class TodoView {
}

class TodoModel {
  constructor(title, task) {
    this.title = title;
    this.task = task;
    this.finished = false;
  }
  finish() {
    this.finished = true;
  }
}
