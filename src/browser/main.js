var app = require('app')
var BrowserWindow = require('browser-window')
var client = require('electron-connect').client
var mainWindow = null

// ウィンドウが全て閉じられた
app.on('window-all-closed', function() {
  app.quit()
})

// Electronのreadyイベント
app.on('ready', function() {
  // ウィンドウの設定
  mainWindow = new BrowserWindow({
    width: 1024,
    height: 768
  })
  // 初回表示するファイルの指定
  mainWindow.loadUrl('file://' + __dirname + '/../renderer/index.html')
  // DevToolsを開く
  mainWindow.openDevTools()
  // Livereload
  client.create(mainWindow)
});
